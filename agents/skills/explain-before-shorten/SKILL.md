---
name: explain-before-shorten
description: >
  Rewrite Japanese explanatory text by first composing how it would be explained aloud, then shortening it without losing meaning.
  When writing or revising explanations in slides, technical documents, emails, READMEs, code comments, docstrings,
  commit messages, pull request or issue descriptions, log messages, or error messages, always use it if the user asks
  「自然な日本語に」「直訳っぽい」「何を言いたいの？」「口頭で説明するように」「わかりやすく短く」「説明してから短くする」,
  even without naming the skill. Preserve technical terms and important conditions, and do not pack unrelated topics into one sentence.
  Not for simple typo fixes, shortening code itself, requests for a literal translation, or requests that only display or export files.
argument-hint: "[分かりにくい表現]"
---

# Explain Before Shorten

Before trying to write briefly, decide how you would explain the point to the reader in person.
Make the text concise by narrowing the topics it covers, not by merely deleting words.

## Invocation

- When the skill is invoked with text and no further instruction, treat that text as the target and rewrite it. Do not ask what to do with it.
- If the text appears in files or messages from the current conversation, rewrite it in that context and apply the edit there, as with "直して".
- Otherwise, return the rewrite as a proposal, without searching unrelated files for it.
- Without any text, the target is the expression under discussion in the conversation.

## Assumptions and scope

- Read the target text and the surrounding context needed to understand it. If figures, tables, or code are part of the explanation, inspect them too.
- Follow any stated reader, purpose, tone, and length. Do not re-ask what the conversation already established.
- No specific tool, MCP server, or authentication is required. Use the tools suited to editing files or checking facts.
- "Explain aloud" is a way to organize the content, not an instruction to make the final text conversational.
- Do not ban technical terms or force a subject into every sentence. Omit what the context makes obvious.
- For reviews or consultations, stop at a proposal. When asked to edit ("直して" and similar), apply the change to the source of truth within the requested range.
- Do not modify unrelated pages, files, code, or existing skills for the sake of smoother prose.

## Procedure

1. **Decide what this explanation must convey.**
   State in one sentence what the reader should understand.
   Match the text's role, such as understanding a mechanism, grasping a difference, carrying out a procedure, or knowing why a change was made.
   Do not bolt adoption decisions or action items onto a conceptual explanation.
   If the purpose cannot be read from the original, check the surrounding context instead of presenting a guess as fact.

2. **First, work out how you would explain it aloud.**
   Ignore length and build the explanation as if the reader were sitting next to you.
   Make "what happens", "why it happens", and "under what conditions" concrete as far as needed.
   Do not let words such as 「分離」「管理」「対応」「保証」 stand in for the actual behavior or condition.
   Distinguish facts, recommendations, and possibilities, and do not invent behavior or effects absent from the original or the code.

3. **Separate distinct topics and choose what belongs here.**
   Distinguish the mechanism, usage conditions, exceptions, and caveats.
   Do not chain different topics, such as execution time limits, required settings, and network latency, into one sentence.
   Place each condition next to the sentence, table cell, or line of code it applies to so its scope is clear.
   Consider dropping or moving redundant notes and off-topic remarks.
   Do not delete applicable conditions or important constraints for length, or hide them only in speaker notes or footnotes.
   Match the medium: a code comment explains why rather than restating the code; a commit message summarizes the change in its subject and gives the reason in its body.
   If a large deletion, move, or restructuring is needed, confirm the requested scope first.

4. **Shorten while preserving meaning.**
   Remove repetition, unnecessary preambles, and roundabout modifiers.
   Keep the actor, action, causality, comparison target, and important conditions readable.
   Do not coin terse private phrases such as 「上限数は到達保証ではない」.
   Keep official terms and identifiers, and add the needed meaning on first use.
   If cutting words is not enough, reduce the topics covered or revisit the structure.
   Do not push decoding onto the reader through smaller text or more abbreviations.

5. **Check that the shortened text works on its own.**
   Confirm that a reader without the long explanation or your spoken commentary can tell what the topic is and what happens.
   Read adjacent sentences together to check for abrupt topic changes or drifting term meanings.
   If it still reads unnaturally, go back to the structure of the explanation instead of repeatedly swapping words.
   If shortening lost meaning, restore the necessary words.

6. **When you edit, verify the saved result and how it renders.**
   Preserve the user's existing changes, and keep the body, tables, figures, notes, and related code consistent.
   Check the result in the form the reader will see it: rendered Markdown or documents, line wrapping and overflow in fixed-size layouts, comment placement next to the code it describes, and formatting conventions or linters for commit messages and docstrings.
   A clean automated check does not guarantee correct rendering. Look at the relevant pages or output directly.
   Do not report unverified content or unsaved parts as checked or applied.

## Rewrite examples

| Over-shortened | Easy to explain aloud |
| --- | --- |
| 受付と完了確認を分離する | 処理の終了を待たずに受付済みと返し、結果は後から問い合わせる |
| 上限数は到達保証ではない | クォータなどの制約により、表の台数まで増やせない場合がある |
| 上限なしでも中断に備える | 実行時間を無制限にしても、サービス側の更新などで処理が止まることがある |
| `// nullチェック対応` | `// 設定ファイルがない環境では config が null になるため、既定値を使う` |

The examples show how to build an expression; do not apply them verbatim to other products or configurations.
Do not replace technical terms the reader needs with vaguer words.

## Output

- Normally show the finished text first, then briefly note only where meaning or structure changed.
- For edit requests, apply the change to the source of truth and briefly report the main changes. Do not repeat the proposal to seek approval again.
- For consultations or reviews, show "what to convey" and the rewrite when useful, and state clearly if nothing was applied.
- Do not include the spoken-explanation draft or deliberation in routine output.

## Handling missing information

| Situation | Response |
| --- | --- |
| The original has multiple readings | Read the surrounding context or code, and ask only if it is still undetermined |
| Technical conditions cannot be confirmed | State what is uncertain, and do not add assertions or guarantees based on guesses |
| The requested length cannot hold the conditions | Do not force compression; present the needed length or a structural change |
| Saving or rendering cannot be verified | Report the text improvement separately from the unverified parts |

## Post-Run Reflection

Finally, silently check that the intended point can be read from the finished text, that no condition was dropped for brevity,
that unrelated topics are not crammed together, and that official terms coexist with natural Japanese.
Also check that you stayed within the proposal or edit scope and did not mark anything complete without verifying the save and rendering.
Apply user corrections within the same conversation, but do not write them back to skills or settings unless asked.
