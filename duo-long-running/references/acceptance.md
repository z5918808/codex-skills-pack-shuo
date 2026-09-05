# Acceptance

Worker: read to build the acceptance packet; Reviewer: read when it arrives. Deliver packets through the [Worker terminal event protocol](worker.md).

## Acceptance Review

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

The Reviewer reloads the pinned authoritative checklist first, then reads current state, diff, and artifacts and checks every criterion against the packet's evidence mapping. Do not substitute the Worker's restated checklist or accept a Worker-proposed waiver. Missing coverage requires `fix-first`; a necessary change to the contract requires `rethink` at the applicable gate.

For high-risk changes, conflicting/unreliable evidence, or a shared repair made by the Reviewer, select the cheapest independent check of the affected contract behavior: an existing read-only probe or bounded fixture that would expose a wrong result, rather than merely repeat the patch's implementation. Reuse decisive current proof when it already covers that behavior; do not rerun the full Worker job or start a third Reviewer. If required corroboration is unavailable, mark `weak verification` and the missing proof; do not `ship` while a required acceptance gate remains unmet. A stronger Reviewer model is not a substitute for this evidence.

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

Reject missing, stale, contradictory, or identity-mismatched evidence. Any later code, artifact, authority, or acceptance-state change invalidates the verdict and requires a new revision and full packet. Never patch or reuse an old packet. Use the existing Reviewer; never create a third one.

For stopped or retired generations, assess execution liveness and native-goal cancellation separately using [lifecycle](lifecycle.md). A lingering active native goal cannot be reported as deleted or as a fully cancelled scheduler. A stop record revokes Worker permission even while native cancellation is unavailable. Acceptance never clears that record or authorizes automatic resumption.
