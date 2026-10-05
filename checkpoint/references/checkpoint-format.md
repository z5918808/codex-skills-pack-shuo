## Checkpoint 格式

```md
# Project Checkpoint

- updated_at: <time and timezone>
- mode: checkpoint / checkpoint-plus-archive-plan / checkpoint-plus-archive-execute / materialize-only
- thread: <thread-or-workstream>
- current_phase: <phase>
- progress: <percent if useful>

## Mainline
- ...

## Verified Facts
- ...

## Materialized Files
- path:
  source:
  purpose:
  verified:

## Archive
- status: none / plan-only / executed
- plan:
- manifest:
- candidates:
- archived:

## Blockers / Risks
- ...

## Next Step
- ...

## Key Files / Verification
- ...

## Handoff Prompt
- ...
```
