---
name: design-audit
description: Use when the user wants a formal scored design audit, preset-based benchmark, or before/after re-audit.
---

# Design Audit

## Boundary

Use for a comparable, evidence-backed design baseline. Use `critique` for open-ended design-director judgment and `audit` for technical accessibility, performance, console, or responsive checks without taste scoring.

## Setup

1. Define the target, primary flow, viewport set, and available runtime or screenshots.
2. Choose a product preset only when it changes weighting: landing page, dashboard, portfolio, ecommerce, mobile-first, accessibility-heavy, or general.
3. Read `references/rubric.md` when producing a formal scorecard.
4. Freeze the fixture so a future re-audit can use the same route, data, states, viewport, and scale.

If only screenshots exist, mark interaction, runtime, responsive, and accessibility conclusions as limited.

## Evidence and Scoring

- Inspect the running interface at desktop and mobile when possible.
- Capture the primary flow and relevant loading, empty, error, success, modal, or form states.
- Score five to seven dimensions on a 1–5 scale only when each score has observed evidence.
- Keep category scores whole. Use a decimal overall average only if the weighting is explicit.
- Treat missing evidence as uncertainty, not an average score.
- Judge against product purpose; do not reward visual novelty over comprehension or task success.

Typical dimensions: purpose, hierarchy, information architecture, interaction, responsive behavior, accessibility, content, trust, and visual system. Select only those relevant to the preset.

## Default Output

Keep it concise:

```text
Overall: <score/5 + two-sentence verdict>
Preset and fixture: <route, state, viewport, evidence limits>
Scorecard: <5-7 rows with score and one evidence note>
Top issues: <at most 3, ordered by impact>
Recommended fixes: <at most 3>
What works: <2 items to preserve>
```

Match the user’s language. Do not maintain a hard-coded translation table inside the skill.

## Re-Audit

Use the same preset, fixture, categories, and evidence method as the baseline. For each previous issue mark `fixed`, `improved`, `open`, or `regressed`, then report score deltas and any new high-impact issue.

If the prior fixture or audit is missing, run a new baseline and state that a valid delta cannot be calculated.

Do not repeat the full original audit. Keep comparison evidence near each changed score or issue.
