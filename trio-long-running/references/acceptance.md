# Acceptance

Worker: read to build the acceptance packet; Reviewer: read when it arrives. Deliver packets through the [Worker terminal event protocol](worker.md).

Reviewer records the [lightweight cost note](lifecycle.md#lightweight-cost-record) alongside the existing review result; it does not alter acceptance criteria or require extra Worker reporting.

## Acceptance Review

Reviewer/Main owns every acceptance review and the final verdict. It reviews current evidence directly and issues `ship`, `fix-first`, or `rethink`. Preserve the actual Main model. Thinker is support-only and never acts as an assigned reviewer, approval source, clearance gate, or verdict owner.

High-risk work (such as production mutation, money, customer data, destructive/bulk effects, or hard-to-reverse recovery), conflicting or unreliable evidence, repeated failures, and consequential semantic/architecture/acceptance uncertainty require stronger evidence and the applicable safety gates. Main may ask Astra for bounded analysis when it would help resolve a genuine judgment gap, but the request is support, not escalation to another reviewer. A task label alone is insufficient: identify the actual effect or unresolved criterion. Routine does not mean merely that Worker claims success. Missing straightforward proof can be obtained or returned as `fix-first` by Main without advisor overhead.

Record Main as the reviewer and the concise evidence/risk basis in the existing review result, not a new gate system. If Main requests Astra support, send only the bounded uncertainty and relevant evidence, then verify the returned advice inside Main's own review. No Thinker verdict, extra reviewer, silent model change, or production takeover.

Existing pinned/user review requirements remain binding until changed at the applicable authority boundary. Under this skill revision, only Main issues or clears `fix-first` and `rethink`; Astra findings are advisory evidence that Main must verify rather than silently adopt or ignore. Adopt changed skill rules only at a safe lifecycle boundary under a new pinned contract, never by editing an active goal.

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

For high-risk changes, conflicting/unreliable evidence, or a shared repair made by the Reviewer, Main selects the cheapest independent check of the affected contract behavior: an existing read-only probe or bounded fixture that would expose a wrong result, rather than merely repeat the patch's implementation. Reuse decisive current proof when it already covers that behavior; do not rerun the full Worker job or start another Reviewer. If required corroboration is unavailable, mark `weak verification` and the missing proof; do not `ship` while a required acceptance gate remains unmet. A stronger Reviewer model or Thinker opinion is not a substitute for this evidence.

When Main requests support, send the original request, pinned checklist, relevant packet reference, affected criteria/dependencies, and exact uncertainty to the independent Astra Thinker through [dispatch](dispatch.md), then resume from its direct result. The Thinker reads the necessary artifacts and tests for that slice and returns advice, counterexamples, and unresolved uncertainty by direct task message under [reporting](reporting.md); Main records receipt and ingestion, verifies the advice, and completes the review itself. No polling or full production rerun. Astra never returns a hash-bound review verdict or certifies any slice.

Main records its verdict locally in the existing acceptance result; no message to itself or Thinker receipt is required unless Main actually assigned a support question. Mere summaries, Worker confidence, or Thinker confidence cannot replace source evidence.

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

- `ship`: Main confirms the complete contract using current evidence. Check packet/hash, generation, authority, and any actually assigned support-result receipt. Main may use verified Astra advice but never treats it as clearance or a delegated reviewer result.
- `fix-first`: the goal is valid but needs bounded correction or proof. Apply [lifecycle](lifecycle.md) before redispatch.
- `rethink`: scope, architecture, authority, safety, or acceptance criteria are wrong. Stop at the real user or authority gate.

Reject missing, stale, contradictory, or identity-mismatched evidence. Any later code, artifact, authority, or acceptance-state change invalidates the verdict and requires a new revision and full packet. Lifecycle-approved recording of the accepted outcome or later reuse of authoritative `TASK_GOAL.md` after closure does not invalidate a recorded verdict for the old generation; it cannot transfer that verdict to the new goal. After correction, Main rechecks findings directly and may send a fresh bounded Astra support question only when a material uncertainty remains. Reverify affected criteria and dependencies and reuse only unaffected current proof. Never patch or reuse an old packet. Use the existing Reviewer; never create another one.

For stopped or retired generations, assess execution liveness and native-goal cancellation separately using [lifecycle](lifecycle.md). A lingering active native goal cannot be reported as deleted or as a fully cancelled scheduler. A stop record revokes Worker permission even while native cancellation is unavailable. Acceptance never clears that record or authorizes automatic resumption.
