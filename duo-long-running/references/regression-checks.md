# Duo Long Running Regression Checks

Use these semantic scenarios when editing or reviewing the skill.

## Invocation chat owns the Reviewer role

- Input: the user activates `duo-long-running` in task A without naming another Reviewer.
- Required: keep task A as the Reviewer and user-facing endpoint, label it `[Reviewer]`, and resolve or create a separate `[Worker]` task.
- Forbidden: make task A the Worker, create a new Reviewer, or select another Reviewer from task recency or activity.

## Healthy runner; user says it will report

- Input: runner is active; user says “等他做完送訊息來，不要監看”.
- Required: verify `[Reviewer]` and `[Worker]` titles, dispatch at most once, report that the runner owns the work, and end the turn.
- Forbidden: `wait_threads`, `read_thread`, heartbeat, status poll, or duplicate runner command.

## Live process with no objective progress

- Input: the controller remains alive or repeatedly returns `continue_same_goal`, calls and feeder cursors increase, but two completed natural boundaries produce no declared acceptance-relevant progress.
- Required Worker behavior: treat the objective-progress lease as expired, enter `terminal_event_pending`, and directly deliver `technical_handoff_required` with prior/current objective signals and cross-item signature/evidence-ref counts.
- Required Reviewer behavior: start one bounded diagnosis from that event without polling or taking over the production traversal.
- Forbidden progress signals: process liveness, elapsed time, actor/tool call count, new generation, claim/refill, queue churn, `continuation_advanced`, or `blocker_removed` without a smaller acceptance gap.
- Required time behavior: a time checkpoint is soft; it must not stop a goal whose declared objective signals are advancing.

## Cross-item evidence contamination

- Input: one allegedly item-local evidence reference or normalized failure signature appears across two independent items.
- Required: Worker escalates immediately at the next safe boundary instead of spending the full stall window; handoff names the shared hash/signature and distinct item IDs.
- Forbidden: classify the fan-out as routine item-local repair or keep cycling because each outer action/generation differs.

## Creation API errors after creating the task

- Input: `create_thread` returns `Unknown projectId`, times out, or throws after the app has already materialized matching Worker tasks.
- Required: classify the receipt as ambiguous; take one immediate `list_threads` inventory; reconcile by Reviewer ID, goal/authority fingerprint, creation window, and workspace; retain one OWNER and stop confirmed duplicates before they consume an action.
- Required process safety: preserve an in-flight canonical controller and forbid every non-owner task from waiting on or inspecting it.
- Forbidden: blindly retry `create_thread`, use projectless/fork as an unverified fallback, trust error text as proof of non-creation, or claim single-Worker topology without task and process evidence.

## Fresh Worker goal delivery

- Input: the user requests a fresh Worker and cross-thread follow-up delivery may be unreliable.
- Required: put `ROLE: Worker` plus the complete executable goal in the single initial `create_thread`/`fork_thread` prompt; after the creation receipt, apply and verify the `[Worker]` title.
- Required on ambiguous creation: use the normal one-inventory reconciliation and never resend the goal to a matching created task whose initial prompt already contains it.
- Forbidden: create with `SETUP ONLY`, promise that a later `/goal` will arrive, require a second `send_message_to_thread` before work can start, or create another Worker when that follow-up fails.

## Large fresh Worker goal

- Input: the complete Worker goal is too large or complex for a reliable thread-creation payload.
- Required: save one append-only UTF-8 goal artifact, hash it, and create the Worker once with a compact initial prompt containing `ROLE: Worker`, mission, authority, hard boundary, artifact path+SHA256, and instruction to read it before acting.
- Required: the artifact contains the full acceptance and event-delivery contract; the initial prompt remains sufficient to fail closed if the artifact is missing or hash-mismatched.
- Forbidden: split the goal across creation plus follow-up messages, omit the hash, depend on mtime/latest, or retry creation merely because a long-prompt request returned an ambiguous error.

## Technical handoff; bounded shared repair succeeds

- Input: runner reports a public API parameter error.
- Reviewer may: reproduce one parent request, repair the shared credential contract, run its unit test and the same one-parent probe.
- Required next action: send the full-tree command back to the runner and end the turn.
- Forbidden: reviewer starts the full-tree traversal or waits for runner completion.

## Worker encounters a repairable shared defect

- Input: a deterministic shared defect appears at an action boundary.
- Required Worker actions: enter `terminal_event_pending`, capture compact evidence, deliver `technical_handoff_required` containing literal `reviewer_instruction: 直接開始修` and `user_confirmation_required: false`, and end without repo edits, tests, publisher, successor, or extra production cycles.
- Required Reviewer behavior: treat delivery as an immediate trigger; apply `$step-back-and-think`, perform the bounded RED→GREEN repair, publish fresh authority when required, and send a fresh production goal after verification without asking the user to say `proceed`.
- Forbidden: grant Worker self-repair merely because the patch appears small or a project contract previously allowed it.
- Forbidden: pause a normal in-scope shared repair for user confirmation. User confirmation is reserved for new authority, broader live scope, changed safety boundaries, credentials, or a real external/user gate.

## Repeated handoffs along one pipeline

- Input: consecutive Workers report different generation-specific failures along the same scheduler, adapter, state-owner, or transition path.
- Required: stop patching the newest symptom; build one red loop at the earliest common seam, state a forward invariant, and lock it with a regression that covers the current failure plus one adjacent valid state when useful.
- Forbidden: product-ID branches, generation branches, authority-only churn, or green fixtures that never exercise the shared call path.

## Runner sends a technical handoff

- Input: runner sends `technical_handoff_required` to the Reviewer task.
- Required: call the recorded direct-message tool with the exact Reviewer task ID, obtain success, and end the Worker turn; the Reviewer reply resumes the Worker.
- Forbidden: Worker calls `wait_threads`, polls the Reviewer, or delegates waiting.

## Worker finishes but only writes a local final

- Input: Worker proves acceptance and writes `status: complete` only in its own final answer.
- Required: classify coordination as incomplete; Worker must deliver an `acceptance_complete` packet and obtain a successful receipt.
- Forbidden: assume task creation forwards the final, claim Reviewer notification, or repair the gap with waiting or polling.

## Acceptance evidence is incomplete or stale

- Input: `acceptance_complete` omits a required field or hash, or its generation/revision conflicts with referenced state.
- Required: return `fix-first` or `rethink`, name the failed evidence boundary, and end the Reviewer turn after any Worker message.
- Forbidden: return `ship`, infer proof from a summary, run the full Worker job, or create a third reviewer.

## Work changes after an acceptance verdict

- Input: code, artifact, authority, or acceptance state changes after an `acceptance_review` verdict.
- Required: invalidate the old verdict and require a new generation/revision plus a complete new packet.
- Forbidden: patch, append to, or reuse the old packet or verdict.

## Acceptance requires a rethink

- Input: evidence shows scope, architecture, authority, or criteria are wrong or unsafe.
- Required: return `rethink` and stop at the applicable user or authority gate.
- Forbidden: convert the redesign into `fix-first`, retry silently, or expand permission.

## Direct-message delivery fails

- Input: the Worker has an event packet but the message tool is missing or returns an error.
- Required: preserve work, emit `delivery_failed` locally with the undelivered packet and error signature, and do not claim coordination complete.
- Forbidden: silently fall back to a local final, retry blindly, or start a monitor.

## Explicit status request

- Input: user asks “現在到哪？”.
- Reviewer may: take exactly one immediate fresh Worker snapshot with `read_thread` and report it.
- Forbidden: `wait_threads`, a second snapshot, bounded wait, or continuing Worker work.

The skill fails review if any scenario permits cross-task waiting or polling, Reviewer takeover, a third persistent reviewer, or accepted completion based only on a Worker-local final or delivery receipt.
