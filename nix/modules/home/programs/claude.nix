{ config, pkgs, lib, ... }:

let
  sharedInstructions = ./../../../../agents/shared-instructions.md;
  sharedSkills = ./../../../../agents/skills;
  claudeSettings = ./../../../../claude/settings.json;
  codexSkillLinks = lib.mapAttrs' (
    name: _: lib.nameValuePair ".codex/skills/${name}" {
      source = sharedSkills + "/${name}";
    }
  ) (lib.filterAttrs (_: type: type == "directory") (builtins.readDir sharedSkills));
in
{
  home.file = {
    ".claude/CLAUDE.md".source = sharedInstructions;
    ".claude/statusline-command.sh".source = ./../../../../claude/statusline-command.sh;
    ".claude/channels/discord/access.json".source = ./../../../../claude/channels/discord/access.json;
    ".codex/AGENTS.md".source = sharedInstructions;
    ".agents/skills".source = sharedSkills;
    ".claude/skills".source = config.home.file.".agents/skills".source;
  } // codexSkillLinks;

  # Claude Code and tools such as Orca write to ~/.claude/settings.json at
  # runtime, so keep it a regular file and deep-merge the repository settings
  # into it; repository values win, keys only present locally are preserved.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    settings="$HOME/.claude/settings.json"
    current='{}'
    if [ -f "$settings" ] && [ ! -L "$settings" ]; then
      current="$(cat "$settings")"
    fi
    merged="$(printf '%s' "$current" | ${pkgs.jq}/bin/jq --slurpfile repo ${claudeSettings} '. * $repo[0]')"
    run mkdir -p "$HOME/.claude"
    if [ -z "''${DRY_RUN:-}" ]; then
      tmp="$(mktemp "$settings.XXXXXX")"
      printf '%s\n' "$merged" > "$tmp"
      mv -f "$tmp" "$settings"
    fi
  '';
}
