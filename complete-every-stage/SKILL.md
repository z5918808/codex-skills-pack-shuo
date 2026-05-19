---
name: complete-every-stage
description: Use when the user wants to continue from the previous staging plan and work in loop, until every previous stage completed, including resolving blockers instead of stopping at them.
---

# Complete Every Stage

First visible line must be exactly:

```text
/goal complete previous all stages
```

Do not put any explanation, status, heading, or preface before that line. Treat it as the entry command for the whole run, then resume the previous staging context as the active execution goal.

Then work in loop, until every previous stage completed:

1. Identify the next incomplete previous stage.
2. Execute the smallest meaningful action for that stage.
3. Verify the result with concrete evidence.
4. Mark the stage completed only after verification.
5. If the stage is blocked, treat the blocker as the current work item and run the smallest safe recovery action.
6. Continue to the next incomplete stage.

Do not create a new staged plan unless the current context lacks one. Do not stop just because a stage is marked `blocked`, `verified blocked`, or behind a recovery gate. Keep working the blocker until it is resolved, downgraded into a smaller safe proof, or converted into a precise external decision.

Stop only when every previous stage completed, or when the next required action truly needs outside input, unavailable credentials, unsafe/destructive permission, production write approval, or user confirmation. In that case, report the exact gate and the smallest thing needed to unblock it.
