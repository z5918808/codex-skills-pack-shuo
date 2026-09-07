# Acceptance

Worker: read to build the acceptance packet; Reviewer: read when it arrives. Deliver packets through the [Worker terminal event protocol](worker.md).

Reviewer records the [lightweight cost note](lifecycle.md#lightweight-cost-record) alongside the existing review result; it does not alter acceptance criteria or require extra Worker reporting.

## Acceptance Review

Main owns final acceptance. For routine Worker work with current, decisive evidence, Sol Main reviews it directly and may issue `ship` without an Astra closing assignment. Preserve the actual Main model; Astra Main can accept directly too.

Escalate to Astra when the affected work is high-risk (such as production mutation, money, customer data, destructive/bulk effects, or hard-to-reverse recovery), evidence conflicts or is unreliable, repeated failures leave the cause unresolved, a consequential semantic/architecture/acceptance judgment remains unresolved, or the user/pinned contract explicitly requires Astra review. A task label alone is insufficient: identify the actual effect or unresolved criterion. Routine does not mean merely that Worker claims success. Missing straightforward proof can be obtained or returned as `fix-first` by Main without advisor overhead; unclear meaning or conflicting proof requires escalation.

Record the selected reviewer and concise routing reason in the existing review result, not a new gate system. With Sol Main, use the same Astra Thinker for the affected slice and dependencies, supplying access to the complete current packet. Main does not complete a duplicate deep review first. With Astra Main, perform that review directly; retain the complementary Sol Thinker for bounded independent checks when needed. No extra reviewer, silent model change, or production takeover.

Existing pinned/user review requirements and unresolved Astra `fix-first`/`rethink` remain binding. Only the same Astra role can clear its affected findings against fresh evidence; Main cannot reclassify them as routine. Adopt changed skill rules only at a safe lifecycle boundary under a new pinned contract, never by editing an active goal.

The Worker delivers:

```text
acceptance_complete
stated_goal_and_acceptance_criteria:
acceptance_checklist_reference_and_sha256:
criterion_id_to_evidence_mapping:
authority_generation_or_revision:
scope_and_actual_changed_paths:
verification_commands_and_actual_results:
artifact_or_diff_paths_and_sha256:
remaining_risk_or_none:
```

The assigned reviewer reloads the pinned authoritative checklist and pre-run readiness evidence first, then reads current state, diff, and artifacts and checks every criterion against the packet's evidence mapping. Confirm that the pre-run false-green case is still rejected and that the actual result satisfies the declared coverage and tolerances. Reuse current applicable proof; run a bounded corroborating check when the evidence cannot distinguish success from that wrong result. Do not substitute the Worker's restated checklist, accept a Worker-proposed waiver, or add a new quality threshold after the run. Missing coverage requires `fix-first`; a necessary change to the contract requires `rethink` at the applicable gate.

For high-risk changes, conflicting/unreliable evidence, or a shared repair made by the Reviewer, select the cheapest independent check of the affected contract behavior: an existing read-only probe or bounded fixture that would expose a wrong result, rather than merely repeat the patch's implementation. Reuse decisive current proof when it already covers that behavior; do not rerun the full Worker job or start a third Reviewer. If required corroboration is unavailable, mark `weak verification` and the missing proof; do not `ship` while a required acceptance gate remains unmet. A stronger Reviewer model is not a substitute for this evidence.

For an escalation with Sol Main, send the original request, pinned checklist, complete packet reference, affected criteria/dependencies, and exact review question to the same Astra task through duo-brainer, then end the turn. Astra reads actual artifacts and tests for that slice and returns a hash-bound verdict by direct message under [reporting](reporting.md), preserving its tool receipt before local final. No polling or full production rerun. Main consumes the result and combines it with unaffected current evidence; an Astra slice verdict alone cannot certify the whole task.

For routine closure, Main records its verdict locally in the existing acceptance result; no message to itself or invented Thinker receipt is required. In either route, mere summaries or Worker confidence cannot replace source evidence.

Return exactly one:

```text
closing_review
packet_identity_or_hash:
reviewer_role_and_actual_model:
review_scope_and_routing_reason:
verdict: ship | fix-first | rethink
reason:
findings:
evidence_references:
unverified_items:
residual_risk:
```

- `ship`: Main confirms the complete contract using current evidence and, for escalated criteria, current Astra clearance. Check packet/hash, generation, authority, and direct receipt for any separate reviewer result. Main cannot upgrade unresolved Astra fix-first/rethink; it may reject stale or unsupported ship.
- `fix-first`: the goal is valid but needs bounded correction or proof. Apply [lifecycle](lifecycle.md) before redispatch.
- `rethink`: scope, architecture, authority, safety, or acceptance criteria are wrong. Stop at the real user or authority gate.

Reject missing, stale, contradictory, or identity-mismatched evidence. Any later code, artifact, authority, or acceptance-state change invalidates the verdict and requires a new revision and full packet. Lifecycle-approved cleanup or reuse of the temporary `TRIO_GOAL.md` after closure does not invalidate a recorded verdict for the old generation; it cannot transfer that verdict to the new goal. After correction, Main rechecks routine findings directly. For Astra-owned findings or new escalation triggers, send the same Astra task the affected slice with the complete revised packet; reverify affected criteria and dependencies and reuse only unaffected current proof. Never patch or reuse an old packet. Use the existing Reviewer; never create a third one.

For stopped or retired generations, assess execution liveness and native-goal cancellation separately using [lifecycle](lifecycle.md). A lingering active native goal cannot be reported as deleted or as a fully cancelled scheduler. A stop record revokes Worker permission even while native cancellation is unavailable. Acceptance never clears that record or authorizes automatic resumption.
