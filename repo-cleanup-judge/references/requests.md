## Good Trigger Examples

- "這個 repo 很吵，幫我判斷哪些能刪"
- "先不要刪，先幫我分 keep / move / delete / ignore"
- "這些 logs / artifacts / snapshots 到底是不是垃圾"
- "我怕刪到動脈，先幫我看哪些只是殘骸"
- "幫我在這個 repo 做 cleanup judgment，不要直接動手"

## One-Shot Prompt Template

Use this when you want another repo-local agent to apply the skill:

```text
Use $repo-cleanup-judge at ~/.codex/skills/repo-cleanup-judge.

Judge this repository's cleanup candidates from live repo truth. Do not delete anything yet.

Task:
1. inspect current docs, runtime/state, logs, and any cleanup scripts
2. build a Keep / Move / Delete / Ignore matrix
3. flag anything that looks important even if it seems noisy
4. tell me the safest smallest cleanup step

Output in Traditional Chinese.
```
