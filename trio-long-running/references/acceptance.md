# Acceptance

Worker: read to build the acceptance packet; Reviewer: read when it arrives. Deliver packets through the [Worker terminal event protocol](worker.md).

Reviewer records the [lightweight cost note](lifecycle.md#lightweight-cost-record) alongside the existing review result; it does not alter acceptance criteria or require extra Worker reporting.

## Acceptance Review

Astra owns closing verification for every goal. With Sol Main, use the same Astra Thinker task that performed opening clarification; Main assembles the complete packet and handles delivery and corrections. With Astra Main, it performs this stage directly. In this section, evidence review and the technical verdict belong to Astra; Main checks identity, authority, and delivery without duplicating the analysis. The TRIO mandatory closing rule overrides duo-brainer's advisory-only and optional-acceptance defaults.

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

Astra reloads the pinned authoritative checklist and pre-run readiness evidence first, then reads current state, diff, and artifacts and checks every criterion against the packet's evidence mapping. Confirm that the pre-run false-green case is still rejected and that the actual result satisfies the declared coverage and tolerances. Reuse current applicable proof; run a bounded corroborating check when the evidence cannot distinguish success from that wrong result. Do not substitute the Worker's restated checklist, accept a Worker-proposed waiver, or add a new quality threshold after the run. Missing coverage requires `fix-first`; a necessary change to the contract requires `rethink` at the applicable gate.

For high-risk changes, conflicting/unreliable evidence, or a shared repair made by the Reviewer, select the cheapest independent check of the affected contract behavior: an existing read-only probe or bounded fixture that would expose a wrong result, rather than merely repeat the patch's implementation. Reuse decisive current proof when it already covers that behavior; do not rerun the full Worker job or start a third Reviewer. If required corroboration is unavailable, mark `weak verification` and the missing proof; do not `ship` while a required acceptance gate remains unmet. A stronger Reviewer model is not a substitute for this evidence.

With Sol Main, before any completion claim, Main sends the original request, pinned opening checklist, current complete packet, and accessible artifact/test references to Astra through [duo-brainer](../../duo-brainer/SKILL.md), then ends the turn. This closing assignment is mandatory even if evidence appears decisive. Astra directly reads the artifacts and actual test results, performs required bounded corroboration within permissions, and returns the review by direct message. A Main summary alone is insufficient. Missing access or proof requires fix-first or rethink, not inferred success. No polling, extra reviewer, or full production rerun.

Astra must send the following result directly to Reviewer under [reporting](reporting.md), preserve the tool receipt, and only then end its turn. A local closing_review is not a delivered verdict. Reviewer must consume it into correction, a real blocker, or accepted delivery.

Return exactly one:

```text
closing_review
packet_identity_or_hash:
verdict: ship | fix-first | rethink
reason:
findings:
evidence_references:
unverified_items:
residual_risk:
```

- `ship`: Astra confirms current evidence satisfies the contract. Main may deliver completion only after checking packet/hash, generation, authority, and successful direct receipt when Astra is separate. Main cannot upgrade fix-first/rethink to ship; it may reject stale or unsupported ship.
- `fix-first`: the goal is valid but needs bounded correction or proof. Apply [lifecycle](lifecycle.md) before redispatch.
- `rethink`: scope, architecture, authority, safety, or acceptance criteria are wrong. Stop at the real user or authority gate.

Reject missing, stale, contradictory, or identity-mismatched evidence. Any later code, artifact, authority, or acceptance-state change invalidates the verdict and requires a new revision and full packet. Lifecycle-approved cleanup or reuse of the temporary `TRIO_GOAL.md` after closure does not invalidate a recorded verdict for the old generation; it cannot transfer that verdict to the new goal. After correction, send the same Astra task a complete revised packet; reverify affected criteria and dependencies and reuse only unaffected current proof. Never patch or reuse an old packet. Use the existing Reviewer; never create a third one.

For stopped or retired generations, assess execution liveness and native-goal cancellation separately using [lifecycle](lifecycle.md). A lingering active native goal cannot be reported as deleted or as a fully cancelled scheduler. A stop record revokes Worker permission even while native cancellation is unavailable. Acceptance never clears that record or authorizes automatic resumption.
