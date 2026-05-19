---
name: resume
description: Use when the user invokes /resume or $resume, says resume, continue where we left off, reconnect, 接回, 繼續剛才, 斷掉後繼續, 不要斷, 回到原本任務, or when a session was interrupted, compacted, restarted, or the assistant must rebuild the active task and continue safely from verified current state.
---

# Resume

## Purpose

Resume interrupted work without losing the mainline. This skill rebuilds the active goal from verifiable evidence, separates current truth from chat memory, and continues the next safe action.

Important: this skill cannot guarantee that Codex App will automatically wake up after every crash or machine shutdown. It defines the recovery protocol to use whenever the conversation resumes or the user invokes `/resume`.

## Core Rules

1. Use Traditional Chinese in user-facing replies.
2. Do not restart from scratch unless evidence shows the old path is unusable.
3. Do not trust chat memory alone. Prefer live files, `_ctx`, status docs, logs, terminal state, git status, running processes, automation state, and latest artifacts.
4. If the newest user message conflicts with older context, follow the newest message.
5. If a prior command, worker, browser session, or long script may still be running, inspect state before launching another one.
6. If the active task involved writes, uploads, money, production data, customer data, destructive actions, or browser-authenticated side effects, resume in read-only/audit mode until the next risky action is explicitly confirmed.
7. If the original task cannot be reconstructed, state that clearly and create the smallest evidence-gathering step.
8. Before claiming work has resumed, identify the current goal, current stage, next action, and verification plan.

## Recovery Workflow

1. Rebuild context.
   - Read the newest user message first.
   - Check whether `_ctx/INDEX.md` exists. If it exists, read it before project-specific action.
   - Look for `PROGRESS.md`, `PROJECT_STATUS`, `AGENT_STARTUP_SOP`, handoff docs, staged plans, TODOs, recent reports, logs, and terminal output.
   - Check git status when inside a repo.
   - Check running processes or existing workers before starting duplicates.

2. Identify the active mainline.
   - Final goal
   - Current milestone or stage
   - Last verified evidence
   - Current blocker
   - Files/artifacts that matter
   - What must not be touched

3. Classify resume confidence.
   - `High`: goal, state, and next step are backed by files/logs/status.
   - `Medium`: goal is clear but next step needs one quick verification.
   - `Low`: only chat memory exists or the state is conflicting.

4. Choose the next safe action.
   - High confidence: continue the next smallest action.
   - Medium confidence: run the missing verification first, then continue.
   - Low confidence: produce a short recovery summary and ask only the one decision needed, or gather evidence if possible.

5. Update durable state when useful.
   - If a project memory system exists, update the relevant progress/handoff file after meaningful resumed work.
   - For long-running work, leave enough state for another fresh session to continue.
   - Do not create new planning files for tiny one-off tasks unless the user asks.

## User Update Format

When resuming, report briefly:

```markdown
目前判斷：
[我接回的是什麼主線。進度 X%。]

已驗證：
- [file/log/process/artifact evidence]

待確認 / 風險：
- [only real uncertainty]

下一步：
[one smallest safe action, then execute if safe]
```

## Stop Gates

Stop and ask before continuing if:

- The task may affect production, database writes, orders, inventory, payments, customer data, or destructive operations.
- The prior state and current filesystem conflict in a way that could cause data loss.
- A duplicate worker or browser automation might submit the same action twice.
- The next step depends on a user-only credential, CAPTCHA, approval, payment, or private decision.

## Handoff Standard

After a successful resume on substantial work, leave a short durable note or final answer that includes:

- What was resumed
- What evidence proved the state
- What changed after resume
- What remains unverified
- The next action if the session drops again

## Relationship To Other Skills

- Use `staging` first when the final goal itself is unclear.
- Use `handoff` when the goal is to create a transfer document for another agent.
- Use `go` or project-specific execution skills after resume has identified the next safe action.
- Use database or production safety skills before resuming risky write operations.
