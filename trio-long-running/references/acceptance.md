# Acceptance

Worker: read to build the acceptance packet; Reviewer: read when it arrives. Deliver packets through the [Worker terminal event protocol](worker.md).

Reviewer records the [lightweight cost note](lifecycle.md#lightweight-cost-record) alongside the existing review result; it does not alter acceptance criteria or require extra Worker reporting.

## Acceptance Review

Division of work follows the adaptive pairing in duo-brainer. Thinker supplies the delegated analysis or high-level challenge; Main sets standards, validates decisive evidence, and owns the final verdict; references below to Reviewer checking describe accountability, not a requirement to repeat all detailed analysis. Do not weaken any criterion or required corroboration.

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

The Reviewer reloads the pinned authoritative checklist and pre-run readiness evidence first, then reads current state, diff, and artifacts and checks every criterion against the packet's evidence mapping. Confirm that the pre-run false-green case is still rejected and that the actual result satisfies the declared coverage and tolerances. Reuse current applicable proof; run a bounded corroborating check when the evidence cannot distinguish success from that wrong result. Do not substitute the Worker's restated checklist, accept a Worker-proposed waiver, or add a new quality threshold after the run. Missing coverage requires `fix-first`; a necessary change to the contract requires `rethink` at the applicable gate.

For high-risk changes, conflicting/unreliable evidence, or a shared repair made by the Reviewer, select the cheapest independent check of the affected contract behavior: an existing read-only probe or bounded fixture that would expose a wrong result, rather than merely repeat the patch's implementation. Reuse decisive current proof when it already covers that behavior; do not rerun the full Worker job or start a third Reviewer. If required corroboration is unavailable, mark `weak verification` and the missing proof; do not `ship` while a required acceptance gate remains unmet. A stronger Reviewer model is not a substitute for this evidence.

Before the verdict, the Reviewer uses [duo-brainer](../../duo-brainer/SKILL.md) when a substantive unresolved analytical question remains. Give one independent complementary Thinker only that question and relevant pinned evidence; do not start another production Worker, subagent, or Reviewer. End the dispatch turn and resume from its direct result, without monitoring. If evidence is already decisive, skip the call. Thinker findings remain advisory; Main verifies consequential claims and owns the verdict. This assistance cannot replace the independent corroborating check required above or waive a missing acceptance gate.

Return exactly one:

```text
acceptance_review
packet_identity_or_hash:
verdict: ship | fix-first | rethink
reason:
findings:
residual_risk:
```

- `ship`: current evidence satisfies the contract. Only this permits user-facing completion.
- `fix-first`: the goal is valid but needs bounded correction or proof. Apply [lifecycle](lifecycle.md) before redispatch.
- `rethink`: scope, architecture, authority, safety, or acceptance criteria are wrong. Stop at the real user or authority gate.

Reject missing, stale, contradictory, or identity-mismatched evidence. Any later code, artifact, authority, or acceptance-state change invalidates the verdict and requires a new revision and full packet. Lifecycle-approved cleanup or reuse of the temporary `TRIO_GOAL.md` after closure does not invalidate a recorded verdict for the old generation; it cannot transfer that verdict to the new goal. Never patch or reuse an old packet. Use the existing Reviewer; never create a third one.

For stopped or retired generations, assess execution liveness and native-goal cancellation separately using [lifecycle](lifecycle.md). A lingering active native goal cannot be reported as deleted or as a fully cancelled scheduler. A stop record revokes Worker permission even while native cancellation is unavailable. Acceptance never clears that record or authorizes automatic resumption.
