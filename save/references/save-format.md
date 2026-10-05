## Recommended Format

```md
# Save Point

- updated_at: 2026-05-05 16:55 Asia/Taipei
- thread: <thread-or-workstream>
- session_marker: <short-human-title>
- save_type: standard / last-known-good
- needs_routing: false

## Current Focus
- ...

## Verified
- ...

## Last Known Good
- works_evidence: ...
- verify_command: ...
- changed_files: ...
- last_safe_step: ...
- next_safe_step: ...

## Risks / Unknowns
- ...

## Next Step
- ...

## Key Files
- ...

## Facts To Promote Later
- ...

## Handoff Prompt
- 下次先讀這份 save，確認 verified / next_step，再直接做下一步。
```

若不是 `last-known-good`，`Last Known Good` 區塊可省略。
