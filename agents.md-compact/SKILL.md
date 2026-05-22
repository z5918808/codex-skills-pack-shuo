---
name: agents.md-compact
description: Use when the user asks to compact, slim, refactor, audit, or de-bloat a project/repo AGENTS.md while preserving high-leverage operating rules. By default this skill only edits repo/project AGENTS.md files; touch global ~/.codex/AGENTS.md only when the user explicitly says global/全域.
---

# agents.md-compact

Use this skill to turn a bloated project `AGENTS.md` into a compact, durable instruction file: core constitution + routing table + project-specific commands. The goal is not to make it tiny at all costs; the goal is to keep only rules that change agent behavior across future tasks.

## Scope Guard

1. Default scope is project/repo only.
2. Do not edit global `~/.codex/AGENTS.md`, `C:\Users\user\.codex\AGENTS.md`, or another user-level instruction file unless the user explicitly says `global`, `全域`, `user-level`, or names that path.
3. If multiple project instruction files exist, inspect the discovery chain and choose the relevant repo-local file closest to the working directory; if the target is ambiguous, report candidates and ask or make the smallest safe project-local change.
4. Preserve project-specific build/test/deploy commands, architecture notes, environment constraints, and safety gates unless they are duplicated elsewhere in a clearly referenced project doc or skill.

## Compact Philosophy

Keep:

- live truth over memory/tool summaries
- verification before completion
- product output + factory output
- 30/60 minute throughput gates for long runs
- incident isolation and blocker escalation rules
- safety boundaries for destructive/high-risk work
- project-specific commands and known traps
- routing to skills/docs/rules for detailed workflows

Remove or move:

- long explanations of why a rule exists
- generic coding advice Codex already knows
- stale tool/version details
- repeated browser/CLI/DB/platform-specific/PowerShell SOPs that belong in skills
- historical reports, handoff essays, examples that are not runtime rules
- duplicated rules that appear in both global and project guidance

## Target Shape

Prefer this shape unless the project has a stronger existing convention:

```md
# AGENTS.md

## Core Invariants
## Project Truth
## Commands
## Execution Default
## Factory / Long-Run Gate
## Tool Routing
## Safety
## Project Memory
## Verification
```

Size targets:

- Healthy project file: usually 8-18 KiB.
- Warning line: 24 KiB.
- If approaching 32 KiB, split details into nested project docs, `_ctx`, skills, or scripts.
- Do not chase byte count by deleting unique project truth.

## Workflow

1. Identify target:
   - current workspace
   - project root
   - discovered `AGENTS.override.md` / `AGENTS.md` files
   - whether user explicitly requested global
2. Measure current file:
   - bytes / KiB
   - line count
   - major headings
   - obvious duplicated sections
3. Classify content:
   - constitution: keep compactly
   - project truth: keep
   - commands: keep
   - tool SOP: route to skill/doc
   - long explanation/report: move or delete from runtime file
   - stale or duplicated rule: remove
4. Rewrite with `apply_patch`.
5. Verify:
   - size reduced and below warning line when feasible
   - project commands still present
   - live truth / verification / safety / factory gates still present
   - no global file changed unless explicitly requested
6. Report:
   - before/after bytes and line count
   - sections kept
   - sections moved/removed
   - remaining risk or missing skill/doc handoff

## Proven Operating Bias To Preserve

When compacting, do not remove these behaviors unless the project explicitly conflicts:

1. 先推整體，再修局部；不要讓單點事故綁架整批工作。
2. Debug 先分清楚問題在產品、工具、環境、權限、流程、資料、還是目標定義。
3. 同一錯誤或 blocker 重複 2 次後，不得第三次用同樣方式嘗試。
4. fallback、stub、retired、降級只能短期止血；主線穩定後優先恢復核心能力。
5. 長腳本或長時間 agent 任務要檢查舊 worker / lock / session；必要時拆 worker 與 log monitor。
6. 背景程序、瀏覽器 session、暫存檔、重複 terminal、殘留 worker 都算現場污染。
7. 單點 incident 未證明是系統性問題時，留下證據、失敗原因、recovery path、下一個可重跑入口，主線繼續。
8. 只有多個獨立樣本重現，或會污染核心流程 / 批次資料 / 使用者可見結果時，才升級為主線 blocker。
9. 可重複利用的規則、腳本、debug route、test command、handoff，要寫回 project docs、skill、script、rules 或 `_ctx`。

## Routing Gap Rule

If compacting removes detailed SOP by routing it to a skill or doc, verify that target exists or clearly mark the gap. If the routed skill/tool/doc does not exist, is not discoverable, or is too weak to carry the workflow, do not pretend the split is complete. Either keep a minimal project-local rule or record the missing factory output.

## Done Criteria

The compacted project `AGENTS.md` is done only when:

- it is materially smaller or clearer
- project-specific commands and safety constraints remain
- long explanations are gone from runtime guidance
- detailed workflows are routed to real skills/docs/scripts
- the final report states whether any Factory output remains to build
