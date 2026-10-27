# Coordination contract

Read before first dispatch and when reconciling stale output, a repair, cancellation, or a restart. The repo/runtime owns storage paths; extend its canonical run record instead of creating a competing source of truth. Without an existing record, use a bounded task-owned temporary run directory outside the repository with one reviewer/captain-owned board and uniquely named immutable packets/artifacts; use a repo directory only when explicitly required as a task artifact. Keep records compact and clean disposable task-owned artifacts under the global storage rules. Creating a local board does not authorize shared or live writes.

## Captain board

Keep enough data to answer who owns an item, why it is ready, and what proves it complete:

- Run: `run_id`, `generation`, original request reference, scope/permission references, acceptance criteria, `rules_ref`, `rules_hash`, `state_version`, squad limit, stop/revocation state.
- Item: `item_id`, deliverable, criterion IDs, prerequisites, input artifact paths/hashes, output contract, permitted output area, forbidden shared paths/actions, owner agent ID, model/effort, status, dispatch receipt, result artifact/hash, acceptance evidence, blocker, release condition, next action.
- Integration: pending accepted artifacts, active writer, target baseline, combined verification evidence, affected descendants, required external gates.

Item progression is `planned → ready → dispatched → working → submitted → accepted → integrated`. Here `accepted` means item-level evidence acceptance, not whole-goal delivery. Repair and blocked states name their reason and return point. Cancellation and supersession remain recorded. Map these fields to existing DAG stage names when required; do not maintain two conflicting status boards.

`dispatched` requires a tool receipt; `working` requires actual output or runtime progress evidence. A waiting process or empty file is insufficient. `ready` requires accepted prerequisite hashes. A released dependency need not wait for unrelated items or final wave closeout.

## Assignment packet

Each packet carries the shared-task fields required by the global contract:

```text
task_id / role / scope / permissions / rules_ref / rules_hash /
state_version / next_action
```

Add the actual `run_id`, generation, item ID, input paths+hashes, output path/format, observable acceptance, stop conditions, selected model/effort, and approved cost/time bounds if provided. Scope identifies both allowed outputs and forbidden actions. Workers receive only relevant context, not sibling transcripts or the entire repository by default.

Workers validate prerequisites and report missing inputs rather than substituting assumptions. They may finish safe independent parts within the packet but cannot change the contract or mark their own item accepted. Worker artifacts include:

- run/generation/item identity and the rules hash actually loaded;
- input baseline and upstream hashes used;
- result or patch, limitations, and relevant raw evidence references;
- executed checks and their actual results, distinguishing not run from passed;
- affected interfaces/files, remaining uncertainty, and an actionable blocker if any.

The compact return envelope remains `status / summary / blocker / artifact path+sha / next_action`. Provenance belongs inside the hashed artifact, avoiding extra transcript fields. Keep artifact bytes fixed after submission; corrections use a new revision and hash.

## Freshness and ownership

An arriving result is eligible only if its task receipt, generation, assigned rule revision, and required input hashes match the currently authorized item. A newer board version due solely to unrelated progress does not invalidate a result; a changed required input or permission does. Recheck the actual destination file baseline immediately before integration.

For stale output, preserve it as evidence but do not automatically merge it or release descendants. The captain may perform an explicit revalidation/rebase in a bounded repair item, producing a fresh artifact against current inputs. A revoked generation cannot be revived by reusing its completion event.

Never assign overlapping shared writes to different owners. Workers may produce competing proposals in separate artifact areas; the captain chooses and applies the result. Contract decisions and final state remain captain-owned. If the captain cannot keep up with submissions, reduce dispatch or enlarge coherent item scope before adding workers.

## Repair and restart

An item repair identifies the failed check, smallest permitted correction, current input hashes, owner, and exit condition. A shared repair also lists paused descendants and the proof that releases them. Do not wait for unaffected siblings to repair one item, and do not remove failed acceptance criteria to make a run green.

On interruption, read the recorded IDs and query those exact workers/processes through the supported runtime. Reconcile completion receipts, artifact hashes, stop status, and ownership before any replacement dispatch. Unknown lifecycle state is a conflict risk, not proof of termination. Account for intentional persistent processes with owner, scope, and stop condition.

Use the host's existing lifecycle record for Main ingestion of terminal results. Its `merged` acknowledgement means ingestion as defined by the current gate; it does not mean that failed/rejected work was applied or accepted. Record that distinction in item status and result summary. Run closeout requires both the lifecycle gate and the captain's separate whole-outcome acceptance.
