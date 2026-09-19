# Required return delivery and Reviewer continuation

Worker and Thinker must read this pinned reference before their first assigned action, after compaction/resume, and before ending an assignment. Reviewer reads it before dispatch and when handling a result. It is the canonical return-delivery contract for both roles; the Worker event protocol supplies its production safe-boundary details. These are instruction-level obligations, not an installed runtime hook or a guarantee that the platform wakes the recipient.

## Persistent-role delivery

Worker and Thinker both return through the direct task-message protocol below. A Luna helper returns only to its persistent Worker; its child final is internal evidence and never substitutes for successful Worker-to-Main delivery. No Thinker child or local final is valid. Main ends the sending turn after dispatch; no waiting or monitoring. Luna may wait only for its own verified helpers under the shared DAG envelope.

## Dispatch must include the return route

Before assigning substantive work, Reviewer records the actual Reviewer chat ID, host ID when supported, destination's authorized model/effort when known, exact callable direct-message tool, assignment ID, run/generation, task scope, this reference path/hash, and the existing external receipt/packet location. Include the route and read-before-action reference in the initial Worker assignment and every actual Thinker support assignment. Never rely on inherited history, titles, a local final answer, or the platform forwarding results automatically. Verify the callable tool supports the route; tool availability is not end-to-end delivery proof. Missing route blocks dispatch, not independent preparation.

## Sender must finish the return before local final

Worker result returns end with one question: 「依整體目標與目前進度，我下一步應完成哪個具體成果？」. Include it with the result, never as a separate nudge. Thinker advice answers the assigned question; consultations ask one concrete decision question rather than appending a generic next-step question. Main retains planning and dispatch ownership.

Ordinary Worker/Thinker returns are content-only: pass `threadId`, `prompt`, and `hostId` when needed; omit `model` and `thinking` entirely, even when the return contract records Main's settings. Those optional fields configure the recipient's next turn, not the cost of composing the report. Before sending, remove either field from copied dispatch arguments. Never copy Luna's max, use minimal for a short report, or restore a historical Main setting. Changing the recipient's model/effort is a separate explicitly user-authorized action, never part of a routine result or acknowledgement. If a transport requires these fields, stop that return with the exact capability mismatch rather than guess.

A finished bounded result, blocker, request for a decision, inability to complete the assignment, or voluntary early stop always requires a direct return to Reviewer. This applies to Worker results and Thinker results. Astra Thinker follows this same direct-return rule. A user stop still requires a safe-boundary status return unless the user explicitly forbids further messaging. Do not end with only a local summary, say that Reviewer can read this chat, or promise to report later. Do not manufacture a blocker to abandon safe assigned work. Routine commentary while continuing a task does not require extra messages.

Use this sequence for every return:

1. Reach the role's safe boundary. A terminal Worker result stops successors and reconciles an in-flight action under worker.md; a permitted nonterminal decision request preserves assignment ownership. Thinker finishes its bounded question. Preserve the compact result and set delivery_state=pending in the existing assignment receipt outside the repo; do not create transcripts or a new tracking system. This does not waive Worker-required terminal handoffs.
2. Build one compact packet: event_id (stable for this logical return), assignment_id, run/generation, sender role/chat ID, Reviewer destination, event type, status, evidence/packet references and hashes, unresolved findings, current owned-action state, and next_action_needed. Include the role-specific Worker payload or Thinker support result. Evidence, advice, or findings do not grant authority or a review verdict.
3. Call the actual direct-message tool to the exact Reviewer chat. The message itself must contain the usable result or accessible packet reference and the requested next action. A comment saying a message was sent is not a tool call.
4. Inspect the tool result. Only an explicit successful delivery receipt permits delivery_state=sent. Record its message/receipt ID when available, otherwise the locatable tool-result reference. Distinguish sent from Reviewer-processed and from accepted completion.
5. Only then end the assignment turn. Local final states the event and that it was sent; it is not a substitute for step 3. No wait for acknowledgement, polling, heartbeat, or acknowledgement-only ping loop.

Before any voluntary assignment-ending final, check whether a required return remains pending. If so, complete delivery first. A transport failure follows the bounded failure path below instead of pretending success. A forced interruption or crash may prevent this check; reconcile from the pending receipt on the next authorized entry, never claim the check ran.

## Evidence and inference in returns

For conclusions affecting a decision or acceptance, distinguish source-supported observations, inference, and unknowns inside the existing result payload. Observations need a locatable original source or actual test result; inferences name supporting evidence and remaining assumptions; unknowns name missing proof. A source stating a claim proves attribution, not necessarily truth. Missing support means unverified, not refuted; refutation needs counterevidence. Do not label every sentence, add a separate report, or count repeated assistant summaries as independent evidence. This applies to Worker findings and Thinker advice without changing verdict ownership.

## Classify a halt before recovery

Use existing status, unresolved findings and next_action_needed fields to identify the actual cause; do not add a parallel state machine. Multiple causes may apply. Stop only dependent work and retain owner and delivery obligations.

- Missing information: name the exact input and obtain it through bounded authorized reads when possible; ask only if it cannot be recovered or inferred reliably. Retrying the operation does not supply the fact.
- Missing authority: name the action and actual absent permission after checking existing authorization. Preserve prepared work; retries or another role cannot supply permission.
- Execution failure: retain the error and known effects. Retry only for an evidenced corrected/recoverable cause within the contract when replay is safe. Preserve two-failure reassessment and third-failure strategy stop; shared defects remain Main-owned repair.
- Unknown outcome: distinguish an unconfirmed write/delivery from confirmed failure. Reconcile current state or supported idempotency proof before replay; otherwise preserve ambiguity and report the exact blocker. Timeout is not proof of non-execution.

These categories do not override the bounded transport rules below, permit polling, reset attempts, or turn a user pause into a retryable failure.

## Bounded transport failure and resume

- A successful send receipt followed by a recipient `unsupported_value` / `reasoning.effort` failure is delivered-but-not-processed, not transport non-delivery. Preserve the original event and artifact references; do not resend the bundle or rerun production. Only explicit user authorization to correct the recipient's settings permits one separate corrective continuation with verified values referencing the delivered event; ordinary return authority does not. Otherwise report the exact mismatch. Do not blindly repeat RESUME, poll for startup, or claim recovery without actual recipient evidence. Skill maintenance alone does not authorize sending that continuation to an active project.
- If the tool definitively confirms non-delivery and the cause can be corrected within existing permissions (for example a validated missing route field), correct that cause and retry once using the same event_id and packet. Do not repeat an unchanged failed call.
- If delivery is ambiguous (timeout, exception, or absent receipt), do not blindly resend: retain delivery_state=unknown. A retry is allowed only if the tool supports an actual idempotency key or supported evidence proves non-delivery; event_id alone does not make the transport idempotent. Do not invent a lookup API or poll the other chat.
- If the bounded recovery fails, the tool is unavailable, or ambiguity cannot be resolved, preserve the packet and exact redacted error and end visibly with delivery_failed, the intended Reviewer/assignment/event, packet reference, and missing recovery action. This is a transport blocker, never a completed handoff. Do not start new production or silently route through another role.
- On a subsequent authorized entry, reconcile only the pending/unknown return before any new assignment. Existing sent receipt forbids duplicate sending. An undelivered completed result permits delivery recovery, never repeated production or analysis; user messaging revocation still wins. Fresh assignment authority cannot silently erase an older undelivered result.

## Consultation and reply

Main's mid-run question to Thinker does not end or transfer Main's work or an independent Worker assignment. Bind question event_id, analysis assignment, parent generation and TASK_GOAL.md hash. Pause dependent work only; a required Worker terminal handoff still follows its lifecycle. Already-dispatched independent work may continue, while Main follows the direct-task result route. No Worker polling or guaranteed uninterrupted Main work.

Before advising, Thinker checks the bound whole-goal outcome and relevant facts; reuse valid same-version context and refresh only stale/missing evidence. Reply to the question event_id and analysis/parent version, distinguish advice from a proposed contract change, and do not modify the goal. Never return `ready`, `ship`, `fix-first`, `rethink`, approval, clearance, or a review verdict. Main consumes the terminal Thinker return, adopts/rejects/verifies it and continues within authority without an acknowledgement-only round. Stale advice cannot revive stopped work, alter a newer assignment or duplicate dispatch. Main alone reviews readiness and acceptance and updates a pinned contract at the required safe boundary. An independent Thinker may receive a new question after its prior terminal return is consumed. Preserve the same independent Thinker and useful unresolved uncertainty for the next authorized question; do not create a child.

## Reviewer must consume the baton

On a direct result, verify destination, role, assignment/generation, event_id, evidence identity and stop state. In the existing receipt, separate consumed input from completed continuation: before effects record event_id, intended next action/assignment and pending status; complete it only with actual dispatch evidence, a verified local result, exact blocker or accepted outcome. On authorized re-entry, reconcile actual effects/delivery and current authority, then finish only the pending part. Consumed input must not erase unfinished continuation; duplicate input cannot repeat completed effects. Unknown delivery follows bounded recovery, never blind resend. No new queue or scheduler.

For every valid actionable result, classify the next operation by its actual effect and the current assignment's owner. Continue work assigned to Worker through lifecycle-approved dispatch to the persistent Luna task, including its remaining item coverage, deliverables and execution reruns. “Worker reusable,” “Worker may continue,” “same goal,” and “next slice ready” preserve that task's identity and ownership; they do not transfer its work to Main or authorize a child to replace the persistent Worker. Luna may internally re-evaluate eligible branches under the shared envelope. Main owns every review, acceptance record, contract/state update, authorized shared code/tooling repair and its bounded verification artifacts under SKILL.md. Judge the operation rather than the filename or whether it is read-only. Resolve an unclear boundary from the current contract before the dependent action; do not stop unrelated authorized work. Thinker is support-only, so a routine successor never requires Thinker re-review.

Then perform or dispatch the next authorized step in the same handling turn, or record the exact blocker/terminal outcome. Do not reply only “received” and leave ready work unassigned. Route as follows:

- Thinker support result: Main adopts, rejects, or verifies the advice, performs its own readiness/review decision, and issues any now-ready dependent assignment. Thinker status never directly authorizes or blocks work.
- Worker acceptance_complete: Main applies acceptance.md and reviews the result from actual evidence. It may send one bounded unresolved question to the same Astra support role, but never dispatches a blanket or required Thinker review solely because the Worker finished.
- Worker technical handoff: perform bounded Reviewer-owned repair and verification, then use the existing lifecycle for correction/redispatch. A user gate is checked against actual authority, not accepted blindly from the packet.

After the substantive successor dispatch receipt, Main may complete the bounded [look-ahead](dispatch.md#main-owned-look-ahead) preparation, then ends the turn. No automatic acknowledgement response is required from its recipient. If no successor is authorized, explicitly name the blocker or completion. A successfully sent event does not prove Reviewer processed it; this receipt distinction must remain visible in any later status diagnosis. Do not introduce monitoring to claim a perfect loop.
