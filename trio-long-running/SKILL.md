---
name: trio-long-running
description: "Run adaptive Astra/Sol Main, a complementary Thinker, and Luna Worker with event handoffs and Main acceptance."
---

# Trio Long Running

Recommended default setup: Sol-high Main (`gpt-5.6-sol/high`), Astra-medium Thinker (`gpt-6-astra/medium`), and Luna-max Worker (`gpt-5.6-luna/max`). This is a starting preference, not an automatic model switch: preserve the user's actual Main model/effort. If Main is Sol, use Astra-medium Thinker unless the user explicitly selects another supported Thinker effort. If Main is Astra, retain the adaptive Sol-high Thinker route. The user selects the Main model in the interface; this skill does not set an application default.

Use this skill for a Reviewer/Worker long run with bounded Thinker assistance. Preserve Main's current supported model: Astra Main uses Sol-high Thinker; Sol Main uses Astra-medium Thinker by default. Pass medium explicitly to duo-brainer for this TRIO route unless the user specifies another supported effort; this TRIO default takes precedence over duo-brainer's question-based effort selection. Follow duo-brainer for the work split and model-switch lifecycle. Luna Worker owns production. Main owns orchestration, shared repair, and delivery; Astra owns mandatory opening clarification and closing verification without duplicated analysis. Editing this skill does not start a run; the project/task contract owns scope and authority.

## Invocation authorizes the prescribed models

An explicit user request to use TRIO supplies the current task's model authorization for the prescribed adaptive Thinker and Luna Worker, including in-scope follow-ups. Capture the invocation text/date and actual task/role/model/effort in the required gate record; no additional "approve Sol/high Thinker?" question. Keep all actual dispatch gates and external/live permission boundaries. If a gate rejects that evidence, diagnose the specific gate mismatch rather than repeatedly asking the user to restate the same approval. Skill maintenance or implicit discovery alone does not grant this authorization.

## Roles

- **Reviewer / Main:** recommended default `gpt-5.6-sol/high`; activation chat unless the user names another; preserve the actual `gpt-6-astra` or `gpt-5.6-sol` model and host-supported effort. Own authority, coordination, the shared-repair single-writer lane, and user-facing delivery. Pin the contract after Astra opening clarification and require Astra closing approval before reporting completion. Use the complementary Thinker for bounded analysis; do not silently switch Main or create another Reviewer. Never inherit Worker permissions or take over production.
- **Worker:** one persistent task, default `gpt-5.6-luna/max`; preserve its selected model and effort. Own one goal and one production action, continuing safe work within the contract without supervision. Handle item-local variation, but set `shared_self_repair_budget=none`: no debugging or patching repo code, shared contracts, schedulers, adapters, authority, or infrastructure. No invented authority, expanded permission, or rescue model. On a shared or deterministic defect, stop at a safe boundary and hand off; no extra production cycle.

- **Thinker:** one independent complementary-model task through [duo-brainer](../duo-brainer/SKILL.md). Sol Main pairs with Astra-medium by default; Astra Main pairs with Sol-high. Pass the TRIO default effort explicitly unless the user selects another supported effort. Follow that skill for task-bound approvals, question selection, and safe switching between assignments. With Sol Main, Astra Thinker owns opening clarification and closing verification, and advises during execution. It never owns production or shared mutations. Start at opening and return to the same task at closure; consult mid-run only when useful.

## Repair ownership does not transfer execution

Before a command with side effects, identify its actual target, effect, assigned role, and current authorization. Judge the operation by what it does, not its label (preview, verification, recovery, test, or repair).

- Reviewer owns shared code/configuration repair within authorized local scope, isolated regression fixtures, necessary bounded read-only checks, and preparation of a no-write preview. The shared-repair single-writer lane never grants live execution ownership.
- Worker owns every production action, including live rollback, recovery writes, a one-item canary, migration, batch execution, and the full production traversal. A small count, urgency, user approval, tool authorship, or a successful repair test never transfers that action to Reviewer or Thinker.
- A preview is Reviewer work only when it is proven no-write against the intended target. A command that combines preview and apply, or whose side effects are uncertain, cannot be run by Reviewer against live data; inspect it or use an isolated fixture first. Necessary bounded read-only verification does not authorize the complete Worker job.
- Once shared repair is verified, Reviewer hands back execution through [repair](references/repair.md) and [dispatch](references/dispatch.md). If Worker is unavailable, reconcile its lifecycle or report the execution blocker; do not take over its production action.
- Astra assesses unresolved technical/safety assumptions and verifies closure; its ready/ship verdict is evidence, never user authorization. Reviewer reconciles actual permission separately and never requests already-granted approval merely because a handoff occurred.

In user-facing plans, identify the executor: Reviewer prepares the preview and repair evidence; Worker executes the authorized rollback; Astra verifies the result. Do not collapse these into “I will confirm and roll back.” These are instruction-level role checks, not an installed command interceptor. An explicit user change of role ownership requires a clear updated contract before execution; do not infer it from ordinary approval to proceed.

## Mandatory Astra opening and closing

TRIO roles are separate persistent user-visible Codex chats with fixed title prefixes: `[Reviewer]` for Main (default Sol high), `[Thinker]` for Astra (default medium), and `[Worker]` for production (default Luna max). Astra retains `[Thinker]` while performing opening and closing reviews; never relabel it as Main/Reviewer. Never implement any delegated TRIO role using spawn_agent, child agents, CLI sessions, or background jobs. The same independent Thinker chat handles opening and closing assignments; direct messages connect the chats. For every TRIO goal, Astra performs two required stages. With the default Sol-high Main, use the same independent Astra-medium Thinker task for both stages and any bounded mid-run advice. Keep that task available after its terminal opening result; it has no active assignment while Worker runs. Reconcile terminal delivery before assigning closing work or corrections. Do not add another reviewer or an extra Astra task. If the user already selected Astra Main, that Main performs the Astra stages directly, with the same evidence requirements; preserve its model/effort and use the complementary Sol Thinker only as needed.

- **Opening clarification:** before dependent production, Astra reads the original request and relevant current evidence, identifies ambiguity, unknowns and assumptions, proposes the smallest useful probes, and derives acceptance criteria and evidence that distinguish success from plausible wrong results. Return `opening_review`, `ready | discovery-needed | blocked`, evidence references, unresolved questions, and proposed criteria. Main pins criteria within the user's scope and arranges authorized probes. A discovery-needed result permits only the bounded discovery it identifies before dependent production; return its evidence to Astra to resolve readiness. Neither role invents answers to user-only decisions or expands permissions. See [dispatch](references/dispatch.md).
- **Closing verification:** Astra directly examines the current artifacts/diff and actual test evidence against the original request and pinned opening criteria. A Main summary or Worker success claim is insufficient. Perform bounded independent checks when required and permitted; unavailable proof remains a gap. Return `closing_review` with `ship | fix-first | rethink`, exact packet identity/hash, evidence references, findings, and unverified items. See [acceptance](references/acceptance.md).

Main arranges corrections and communicates the outcome, but cannot waive either stage or upgrade Astra's fix-first/rethink verdict to ship. Main may reject a stale or unsupported ship and seek correction. Completion requires current Astra ship plus Main's identity, authority, and delivery checks. After corrections, the same Astra task rechecks affected criteria and their dependencies against a complete revised packet; reuse unaffected current proof rather than rerun all production. Mid-run advice remains advisory. These TRIO stage ownership and mandatory review rules override duo-brainer's optional-consultation and Main-only acceptance defaults only within TRIO; retain its dispatch, permissions, and direct-result lifecycle. Missing Astra capability blocks the required stage, not independent authorized preparation.

## Main decision framework and advisor timing

Between the mandatory opening and closing stages, Main evaluates uncertainty and impact before a consequential assignment or decision, after a repeated failure, and when acceptance evidence conflicts. Use the cheapest decisive evidence; this is not a mandatory ceremony for every action.

| Situation | Main action | Thinker timing |
| --- | --- | --- |
| Clear goal, familiar method, reversible action | Decide directly and assign scoped production to Worker. | Skip consultation. |
| Missing facts such as file locations, current behavior, or test results | Obtain bounded read-only evidence within existing role permissions. | Gather facts first; do not use the advisor for routine lookup. |
| Necessary facts are available, but architecture or competing approaches materially affect downstream work | Frame the options, tradeoffs, and unresolved decision. | Consult before dependent implementation. |
| Broad-impact or hard-to-reverse decision still rests on a material unverified assumption | Pause only dependent work and ask for an assumption challenge. | Consult before committing; advice never replaces user authorization or applicable safety gates. |
| The same problem fails a second time and the current explanation is insufficient | Compare both failures, identify the shared cause, and change strategy. | Consult when a different analytical perspective is needed; do not retry unchanged while waiting. A third occurrence stops that strategy under the existing failure rule. |
| Acceptance evidence conflicts or its meaning against a criterion remains unresolved | Isolate the discrepancy and the exact criterion it affects. | Consult before the verdict. |
| Current evidence decisively satisfies acceptance | Send the complete evidence packet to Astra for closing verification. | Mandatory closing review; skip only redundant mid-run consultation. |

Missing facts call for evidence gathering; a material judgment gap after that calls for advice. Delegate before doing the full analysis yourself, and never duplicate an active Thinker assignment. This framework does not authorize extra scouts, subagents, or production owners. Independent authorized Worker work may continue while a separate decision is investigated.

Each consultation supplies five concise items within the existing duo-brainer dispatch packet:

1. The decision to make and when it is needed.
2. Relevant evidence references, constraints, and permission boundaries.
3. Candidate options and Main's provisional inclination, if any, without a full duplicate analysis.
4. The specific uncertainty or assumption to challenge, including evidence that could overturn the inclination.
5. The requested result: recommendation, decisive reasons, counterexample or failure condition, and cheapest useful verification, with a bounded stopping condition.

After the direct result arrives, Main chooses to adopt, reject, or verify the advice and briefly states the evidence-based reason in the existing decision/response. For mid-run advice, Main owns the decision; the mandatory Astra opening and closing requirements remain binding. Besides the mandatory closing assignment, send a follow-up only for new evidence or a remaining substantive gap, using the existing terminal-delivery and safe reassignment lifecycle. Do not create a separate decision log or require an advisor call at every step. If advice cannot be obtained, continue independent authorized work and report only the decision that remains blocked; never claim consultation occurred.

## TRIO_GOAL.md only; never Goal mode

`TRIO_GOAL.md` is the single reusable task-contract document, not Codex Goal mode. Main writes scope, permissions, acceptance, run/generation, Thinker/Worker responsibilities, return address, and stop conditions; dispatched tasks verify its applicable identity/hash. Thinker receives only the relevant research slice and cannot edit the goal. Preserve the existing safe-reuse lifecycle: no overwrite/delete until prior owned work is terminal or safely cancelled and required review is resolved.

Never activate native Goal mode for Main, Thinker, or Worker: no `/goal` dispatch trigger, `create_goal`, native-goal continuation, or substitute heartbeat/recurring scheduler. A `goal_mode=file-contract` field in existing packet schemas means this document-only contract and grants no native-mode permission. References to legacy native goals are solely for stopping/reconciling already-existing state, never an allowed execution route. Work continues through direct task result messages; Main ends its turn between actionable events.

## Non-Negotiable Invariants

1. Use exactly one persistent Reviewer task and one persistent production Worker task. With Sol Main, use one separate Astra Thinker chat for required opening and closing and bounded mid-run advice; exactly three role chats, no subagents or extra Reviewer/Worker. Preserve an explicitly selected Astra Main route as described above; never silently change Main.
2. Never use `spawn_agent`, child agents, subagents, CLI sessions, or local background jobs for any delegated TRIO role. Main cannot substitute its own turns for the independent Thinker or Worker chat.
3. Never use `wait_threads`, polling, heartbeat, recurring automation, filesystem polling, or process polling to watch the other task.
4. The Worker owns production traversal. The Reviewer may diagnose and repair a shared defect with a bounded fixture, but never runs the Worker's full job.
5. A Worker-local final is not delivery. A terminal event needs a successful direct-message tool receipt.
6. A Worker acceptance claim is not completion. Astra must return current closing `ship`; Main may report completion only after checking its packet identity, authority, and delivery. Sol cannot overrule Astra rejection.
7. Never layer a new goal over an unfinished Worker goal.
8. Never expand scope, permission, credentials, or safety boundaries without the required user gate.
9. A stop from the user or Reviewer revokes the current generation. Persist and check its stop record on every Worker entry, including automatic continuation; an active native goal is not permission to resume.

If persistent task lifecycle or direct task messaging is unavailable, fail closed. Do not emulate TRIO with a subagent. If TRIO mistakenly used a subagent, stop only that subagent before its next action, keep read-only observations as non-authoritative, and restart with one persistent Worker.

## Closing review and mid-run advice

Apply the mandatory Astra stages above and [acceptance](references/acceptance.md) at closure. Mid-run analysis follows the decision framework through [duo-brainer](../duo-brainer/SKILL.md). All stages use the same single Thinker slot and direct-result protocol; no subagents, production takeover, polling, or extra reviewer. Closing review is required even when Main considers the evidence decisive.

## Authority and Acceptance

Astra derives the acceptance checklist at opening; Main reconciles it with user authority and pins it from the user/project contract before considering Worker conclusions. Worker packets provide evidence; they cannot change scope, remove criteria, lower thresholds, or waive requirements. Contract changes require the applicable authority/user gate and a new checklist revision.

Worker diagnoses and `reviewer_instruction` / `user_confirmation_required` fields are advisory, never authority. Reviewer checks evidence and existing permission independently. A false flag cannot waive a gate; a true flag does not create one. Continue authorized repair without redundant confirmation.

## Read Only the Current Workflow

Read the applicable reference before its action. Do not preload every reference or make the Worker read Reviewer repair instructions. Keep shared rules in these files; goal packets identify the applicable immutable references/hashes instead of copying the whole skill.

| Trigger / role | Reference |
| --- | --- |
| Reviewer: initial dispatch or a fresh goal | [Dispatch](references/dispatch.md): establish pre-run readiness and a discriminating acceptance check before preparing the Worker goal |
| Worker or Thinker: assignment entry, resume, and before final; Reviewer: dispatch/result | [Required reporting](references/reporting.md) |
| Worker: before its first production action | [Worker execution](references/worker.md) |
| Reviewer: received technical handoff | [Bounded repair](references/repair.md) |
| Goal reuse/replacement, dead transport, or explicit pause | [Lifecycle](references/lifecycle.md) |
| Worker: prepare acceptance packet; Reviewer: judge it | [Acceptance](references/acceptance.md) |
| Review/edit this skill only | [Semantic regression scenarios](references/regression-checks.md) |

After any cross-task goal, handoff, repair result, decision, or event message, the sender ends its turn. The next direct message resumes the receiver; neither side waits for a reply. Delivery failure preserves the undelivered packet and stops locally, never silently becoming completion.

An explicit user pause or Reviewer stop uses [lifecycle cancellation](references/lifecycle.md); it never creates a replacement. TRIO uses one reusable `TRIO_GOAL.md` at a fixed workspace path, with no native `/goal` or `create_goal`. The Reviewer may overwrite or delete it only after the prior Worker is safely stopped and required review is resolved; see [goal file lifecycle](references/lifecycle.md). Do not create a separate goal file per run or generation. Native-mode procedures cover already-existing native goals, not new TRIO dispatches. Resume needs fresh authority and a new generation; a scheduler continuation supplies neither.

## Required return delivery

Both Worker -> Reviewer and Thinker -> Reviewer must follow [Required return delivery and Reviewer continuation](references/reporting.md). Pin that reference and the actual return route in every assignment. Before ending an assignment, send the result/blocker with the direct-message tool and preserve its receipt; local final text alone is a protocol failure. Reviewer must process each valid actionable result into an authorized successor, exact blocker, or accepted completion. Delivery failures use the bounded recovery in that reference; do not silently stop, blindly retry, or claim guaranteed runtime wake-up.

## Main yields while delegated work runs

- Main delegates substantive thinking to Thinker and production to Worker, then ends its current turn after the dispatch receipt. While either is running, do not keep Main sampling, sleep/wait, poll, monitor, issue filler status turns, or duplicate its analysis/execution. This applies to Astra Main and Sol Main alike. Ending the turn is the requested pause/disconnect; it does not mean closing the App, terminating user processes, or cancelling the delegated task.
- Thinker and Worker deliver their bounded result, blocker, or terminal event directly to Main with a successful tool receipt, then end their own turn. Main resumes from that event, checks current generation and evidence, decides the next eligible assignment or verdict, dispatches if needed, and ends again. A routine progress event with no decision needed does not justify more Main work.
- Preserve dependency ordering: accept Thinker input before assigning dependent Worker work. Do not start dependent production merely to keep both tasks busy. Existing independent authorized Worker work may continue while Thinker analyzes a separate question.
- A user message may resume Main for a decision, status request, or stop; handle only that request and any genuinely ready event, then yield again if delegated work remains. An automatic continuation without a new actionable event must end immediately, not restart or duplicate work. User stop/revocation always overrides event continuation.
- This long run advances by direct task events, never by keeping Main awake or adding a scheduler. Verify actual messaging capability before dispatch; missing delivery cannot be replaced by polling or claimed as completion. Do not claim zero tokens, billing suspension, or reliable wake-up without runtime evidence.

## Status Reads

Normal TRIO work uses no cross-task reads after dispatch. Exceptions:

- one immediate inventory/title snapshot during dispatch reconciliation;
- one immediate `read_thread` snapshot to prove a new or replacement Worker started;
- at most one immediate `read_thread` snapshot needed to reconcile a delivered Worker event during repair or acceptance; this is event handling, never monitoring;
- one immediate `read_thread` snapshot after an explicit user status request.

For a status request, report that single snapshot and return idle. Never use `wait_threads` or take a second snapshot. User text such as “不要監看” or “等他送訊息來” is an absolute no-monitor flag until a Worker event or a later explicit status request permits one read.

## User-Facing Progress

During an active run, each dispatch, status, handoff, and acceptance update contains exactly one top-level line:

```text
<final outcome label>：N%
```

Use the user's label when supplied. Base `N` on the full acceptance contract and Reviewer-verified evidence only. Do not count time, liveness, calls, queues, Worker confidence, or an unsupported terminal claim. Hide substage percentages unless asked. Cap at 99% before `ship`; use 100% only after `ship`. If the denominator changes, state the new basis.

## Done

End TRIO only when:

- the newest complete packet matches current state, Astra returns closing `ship`, and Main completes the identity/authority/delivery checks; or
- a real user or external gate remains after authorized recovery.

Before reporting completion, verify:

- neither task owns a cross-task wait or monitor;
- the Reviewer owns no duplicate Worker command;
- there is one Worker OWNER and no duplicate controller/writer;
- all existing role chats retain the correct `[Reviewer]`, `[Thinker]`, and `[Worker]` prefixes;
- the last terminal event has a successful direct-message receipt;
- for accepted completion, packet revision/hash, Astra closing `ship`, its direct delivery receipt when Astra is a separate task, and no post-verdict change all match.

Report the delivered outcome first. Keep lifecycle noise out of the user-facing result.

For skill maintenance, run the linked semantic scenarios. Review fails on subagent Workers, cross-task monitoring/waiting, Reviewer production takeover, a third Reviewer, Worker-controlled acceptance or authority, or completion from a local final/delivery receipt alone.
