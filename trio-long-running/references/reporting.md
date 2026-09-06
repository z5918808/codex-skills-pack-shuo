# Required return delivery and Reviewer continuation

Worker and Thinker must read this pinned reference before their first assigned action, after compaction/resume, and before ending an assignment. Reviewer reads it before dispatch and when handling a result. It is the canonical return-delivery contract for both roles; the Worker event protocol supplies its production safe-boundary details. These are instruction-level obligations, not an installed runtime hook or a guarantee that the platform wakes the recipient.

## Dispatch must include the return route

Before assigning substantive work, Reviewer records the actual Reviewer chat ID, host ID when supported, exact callable direct-message tool, assignment ID, run/generation, task scope, this reference path/hash, and the existing external receipt/packet location. Include the route and read-before-action reference in the initial Worker and Thinker assignment, including opening, advice, closing, and correction work. Never rely on inherited history, titles, a local final answer, or the platform forwarding results automatically. Verify the callable tool supports the route; tool availability is not end-to-end delivery proof. Missing route blocks dispatch, not independent preparation.

## Sender must finish the return before local final

A finished bounded result, blocker, request for a decision, inability to complete the assignment, or voluntary early stop always requires a direct return to Reviewer. This applies equally to Worker results and Thinker opening_review, advice, closing_review, and correction results. A user stop still requires a safe-boundary status return unless the user explicitly forbids further messaging. Do not end with only a local summary, say that Reviewer can read this chat, or promise to report later. Do not manufacture a blocker to abandon safe assigned work. Routine commentary while continuing a task does not require extra messages.

Use this sequence for every return:

1. Reach the role's safe boundary. Worker stops successors and reconciles an in-flight action under worker.md. Thinker stops the completed bounded assignment. Preserve the compact result and set delivery_state=pending in the existing assignment receipt outside the repo; do not create transcripts or a new tracking system.
2. Build one compact packet: event_id (stable for this logical return), assignment_id, run/generation, sender role/chat ID, Reviewer destination, event type, status, evidence/packet references and hashes, unresolved findings, current owned-action state, and next_action_needed. Include the role-specific opening/closing/Worker payload. Evidence or findings do not grant authority.
3. Call the actual direct-message tool to the exact Reviewer chat. The message itself must contain the usable result or accessible packet reference and the requested next action. A comment saying a message was sent is not a tool call.
4. Inspect the tool result. Only an explicit successful delivery receipt permits delivery_state=sent. Record its message/receipt ID when available, otherwise the locatable tool-result reference. Distinguish sent from Reviewer-processed and from accepted completion.
5. Only then end the assignment turn. Local final states the event and that it was sent; it is not a substitute for step 3. No wait for acknowledgement, polling, heartbeat, or acknowledgement-only ping loop.

Before any voluntary assignment-ending final, check whether a required return remains pending. If so, complete delivery first. A transport failure follows the bounded failure path below instead of pretending success. A forced interruption or crash may prevent this check; reconcile from the pending receipt on the next authorized entry, never claim the check ran.

## Bounded transport failure and resume

- If the tool definitively confirms non-delivery and the cause can be corrected within existing permissions (for example a validated missing route field), correct that cause and retry once using the same event_id and packet. Do not repeat an unchanged failed call.
- If delivery is ambiguous (timeout, exception, or absent receipt), do not blindly resend: retain delivery_state=unknown. A retry is allowed only if the tool supports an actual idempotency key or supported evidence proves non-delivery; event_id alone does not make the transport idempotent. Do not invent a lookup API or poll the other chat.
- If the bounded recovery fails, the tool is unavailable, or ambiguity cannot be resolved, preserve the packet and exact redacted error and end visibly with delivery_failed, the intended Reviewer/assignment/event, packet reference, and missing recovery action. This is a transport blocker, never a completed handoff. Do not start new production or silently route through another role.
- On a subsequent authorized entry, reconcile only the pending/unknown return before any new assignment. Existing sent receipt forbids duplicate sending. An undelivered completed result permits delivery recovery, never repeated production or analysis; user messaging revocation still wins. Fresh assignment authority cannot silently erase an older undelivered result.

## Reviewer must consume the baton

On a direct result, verify destination, role, assignment/generation, event_id, evidence identity, and stop state. Record consumed event_id in the existing receipt before a successor that could duplicate effects. Ignore duplicate/stale events for execution; retain the reason without an acknowledgement loop. A result already consumed cannot dispatch a second successor.

For every valid actionable result, Reviewer performs or dispatches the next authorized step in the same handling turn, or records the exact blocker/terminal outcome. Do not reply only “received” and leave ready work unassigned. Route as follows:

- Thinker opening ready: pin the authorized criteria and dispatch the eligible Worker assignment. discovery-needed: arrange the bounded discovery and return evidence to the same Thinker. blocked: resolve authorized preparation or identify the missing user/dependency decision.
- Worker acceptance_complete: send the complete current packet to the same Thinker for mandatory closing verification.
- Worker technical handoff: perform bounded Reviewer-owned repair and verification, then use the existing lifecycle for correction/redispatch. A user gate is checked against actual authority, not accepted blindly from the packet.
- Thinker advice: adopt, reject, or verify with evidence and issue any now-ready dependent assignment.
- Thinker closing fix-first: assign in-scope correction to its proper owner, then return revised evidence to the same Thinker. rethink: resolve the substantive contract issue within authority or report the exact gate. ship: check current packet, authority, and delivery and deliver the accepted outcome.

End after the substantive successor dispatch receipt. No automatic acknowledgement response is required from its recipient. If no successor is authorized, explicitly name the blocker or completion. A successfully sent event does not prove Reviewer processed it; this receipt distinction must remain visible in any later status diagnosis. Do not introduce monitoring to claim a perfect loop.
