#!/usr/bin/env zsh

set -euo pipefail

readonly endpoint="http://127.0.0.1:50021"
readonly speaker_name="猫使ビィ"
readonly max_sentence_chars=140
readonly docker_command="docker run --rm --gpus all -p '127.0.0.1:50021:50021' voicevox/voicevox_engine:nvidia-latest"
readonly script_name="${0:t}"

typeset -Ar style_names=(
  normal "ノーマル"
  calm "おちつき"
  shy "人見知り"
  strong "つよつよ"
)

typeset -a player_command
typeset -a sentence_styles
typeset -a sentences
typeset -A style_ids
typeset speakers_json=""
typeset work_dir=""
typeset playback_pid=""

print_usage() {
  print -u2 -- "使い方:"
  print -u2 -- "  $script_name --check"
  print -u2 -- "  $script_name <normal|calm|shy|strong> <一文> [<style> <一文> ...]"
}

fail() {
  local message="$1"
  local exit_code="${2:-1}"

  print -u2 -- "$message"
  exit "$exit_code"
}

report_engine_unavailable() {
  print -u2 -- "VOICEVOXエンジンへ接続できないよ。"
  print -u2 -- "ユーザーに次のコマンドの実行をお願いしてね:"
  print -u2 -- "$docker_command"
  exit 69
}

select_player() {
  if command -v pw-play >/dev/null 2>&1; then
    player_command=(pw-play)
  elif command -v ffplay >/dev/null 2>&1; then
    player_command=(ffplay -nodisp -autoexit -loglevel error)
  elif command -v aplay >/dev/null 2>&1; then
    player_command=(aplay -q)
  else
    fail "音声プレーヤーが見つからないよ。pw-play、ffplay、aplayのどれかが必要だよ。" 69
  fi
}

check_dependencies() {
  local command_name

  for command_name in curl jq mktemp rm; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      fail "必要なコマンドが見つからないよ: $command_name" 69
    fi
  done

  select_player
}

fetch_speakers() {
  if ! speakers_json="$(
    curl -fsS \
      --connect-timeout 2 \
      --max-time 5 \
      "${endpoint}/speakers" \
      2>/dev/null
  )"; then
    report_engine_unavailable
  fi

  if ! print -r -- "$speakers_json" | jq -e 'type == "array"' >/dev/null 2>&1; then
    fail "VOICEVOXエンジンから不正な話者情報が返ってきたよ。" 70
  fi
}

resolve_style_id() {
  local style_key="$1"
  local style_name="${style_names[$style_key]-}"
  local style_id

  if [[ -z "$style_name" ]]; then
    fail "知らないスタイルだよ: $style_key" 64
  fi

  if [[ -n "${style_ids[$style_key]-}" ]]; then
    return
  fi

  if ! style_id="$(
    print -r -- "$speakers_json" |
      jq -er \
        --arg speaker "$speaker_name" \
        --arg style "$style_name" \
        '[
          .[]
          | select(.name == $speaker)
          | .styles[]
          | select(.name == $style and ((.type // "talk") == "talk"))
          | .id
        ][0]'
  )"; then
    fail "猫使ビィの「${style_name}」スタイルが見つからないよ。VOICEVOXエンジンを更新してね。" 69
  fi

  style_ids[$style_key]="$style_id"
}

validate_sentence() {
  local style_key="$1"
  local text="$2"

  if [[ -z "${style_names[$style_key]-}" ]]; then
    fail "知らないスタイルだよ: $style_key" 64
  fi

  if [[ -z "${text//[[:space:]]/}" ]]; then
    fail "空の文は読み上げられないよ。" 64
  fi

  if [[ "$text" == *$'\n'* || "$text" == *$'\r'* ]]; then
    fail "一度に渡せるのは改行を含まない一文だけだよ。" 64
  fi

  if (( ${#text} > max_sentence_chars )); then
    fail "一文が長すぎるよ。${max_sentence_chars}文字以内の自然な文に分けてね。" 64
  fi

  if [[ "$text" =~ '[。！？!?][[:space:]]*[^。！？!?[:space:]]' ]]; then
    fail "一つの引数に複数の文を入れず、文ごとにスタイルとの組へ分けてね。" 64
  fi

  if [[ "$style_key" == "strong" && "$text" != "タスクに成功しました！" ]]; then
    fail "strongは「タスクに成功しました！」だけに使ってね。" 64
  fi
}

cleanup() {
  local exit_code="$?"

  if [[ -n "$playback_pid" ]] && kill -0 "$playback_pid" >/dev/null 2>&1; then
    kill "$playback_pid" >/dev/null 2>&1 || true
    wait "$playback_pid" >/dev/null 2>&1 || true
  fi

  if [[ -n "$work_dir" && "$work_dir" == /tmp/voicevox-bee.* && -d "$work_dir" ]]; then
    rm -rf -- "$work_dir"
  fi

  return "$exit_code"
}

engine_is_available() {
  curl -fsS \
    --connect-timeout 2 \
    --max-time 5 \
    "${endpoint}/version" \
    >/dev/null 2>&1
}

synthesize_sentence() {
  local index="$1"
  local total="$2"
  local style_key="${sentence_styles[$index]}"
  local text="${sentences[$index]}"
  local style_id="${style_ids[$style_key]}"
  local query_file="${work_dir}/query-${index}.json"
  local audio_file="${work_dir}/audio-${index}.wav"

  print -- "合成開始 [$index/$total]: ${style_names[$style_key]}"

  if ! curl -fsS \
    --retry 2 \
    --retry-delay 1 \
    --retry-all-errors \
    --connect-timeout 2 \
    --max-time 180 \
    -X POST \
    "${endpoint}/audio_query" \
    -G \
    --data-urlencode "text=$text" \
    --data-urlencode "speaker=$style_id" \
    -o "$query_file"; then
    print -u2 -- "audio_queryに失敗したよ [$index/$total]"
    return 1
  fi

  if ! jq -e 'type == "object"' "$query_file" >/dev/null 2>&1; then
    print -u2 -- "audio_queryの応答が不正だったよ [$index/$total]"
    return 1
  fi

  if ! curl -fsS \
    --retry 2 \
    --retry-delay 1 \
    --retry-all-errors \
    --connect-timeout 2 \
    --max-time 180 \
    -X POST \
    "${endpoint}/synthesis?speaker=${style_id}" \
    -H "Content-Type: application/json" \
    --data-binary "@$query_file" \
    -o "$audio_file"; then
    print -u2 -- "synthesisに失敗したよ [$index/$total]"
    return 1
  fi

  if [[ ! -s "$audio_file" ]]; then
    print -u2 -- "空の音声が生成されたよ [$index/$total]"
    return 1
  fi

  print -- "合成完了 [$index/$total]"
}

start_playback() {
  local index="$1"
  local total="$2"
  local audio_file="${work_dir}/audio-${index}.wav"

  print -- "再生開始 [$index/$total]"
  "${player_command[@]}" "$audio_file" &
  playback_pid="$!"
}

wait_for_playback() {
  local index="$1"
  local total="$2"
  local current_pid="$playback_pid"

  if ! wait "$current_pid"; then
    playback_pid=""
    print -u2 -- "音声再生に失敗したよ [$index/$total]"
    return 1
  fi

  playback_pid=""
  print -- "再生完了 [$index/$total]"
}

check_dependencies

if (( $# == 1 )) && [[ "$1" == "--check" ]]; then
  fetch_speakers
  for style_key in normal calm shy strong; do
    resolve_style_id "$style_key"
  done
  print -- "VOICEVOXエンジンと猫使ビィの全スタイルを使えるよ。"
  exit 0
fi

if (( $# == 0 || $# % 2 != 0 )); then
  print_usage
  exit 64
fi

while (( $# > 0 )); do
  validate_sentence "$1" "$2"
  sentence_styles+=("$1")
  sentences+=("$2")
  shift 2
done

fetch_speakers
for style_key in "${sentence_styles[@]}"; do
  resolve_style_id "$style_key"
done

readonly total="${#sentences[@]}"
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'exit 129' HUP
work_dir="$(mktemp -d /tmp/voicevox-bee.XXXXXXXX)"

synthesize_sentence 1 "$total" || {
  if ! engine_is_available; then
    report_engine_unavailable
  fi
  fail "最初の文を合成できなかったよ。" 70
}

integer index next_index
for (( index = 1; index <= total; index++ )); do
  start_playback "$index" "$total"
  next_index=$(( index + 1 ))

  if (( next_index <= total )); then
    if ! synthesize_sentence "$next_index" "$total"; then
      wait_for_playback "$index" "$total" || true
      if ! engine_is_available; then
        report_engine_unavailable
      fi
      fail "次の文を合成できなかったよ [$next_index/$total]" 70
    fi
  fi

  if ! wait_for_playback "$index" "$total"; then
    exit 74
  fi
done

print -- "すべての読み上げが終わったよ。"
