---
name: impeccable-design-workflow
description: "Use when UI, landing page, app-shell, component, or visual refresh work needs the Impeccable skill set but the right command is not obvious. Use for choosing among /impeccable teach, /shape, /critique, /audit, /typeset, /layout, /colorize, /quieter, /bolder, /distill, /polish, /optimize, and related Impeccable skills based on the current stage, problem, or anti-slop need."
---

# Impeccable Design Workflow

## Overview

Route design work to the right Impeccable command at the right time. This skill is an orchestrator: it does not replace the installed Impeccable skills, it decides which one to use now and why.

If the problem is still fuzzy, pick a planning command. If the problem is already visible, pick a diagnostic or surgical command. If the work is nearly done, pick a finishing command.

Use `design3steps` for the conservative baseline workflow. Use this skill when the user wants the full Impeccable family or when the command choice is non-obvious.

## Hard Rules

1. Prefer project `DESIGN.md` first. If missing, fall back to the global design template.
2. Before visual work, inspect at least 3 relevant reference systems when design quality matters.
3. Treat `impeccable.style` as an anti-pattern and critique reference, not as the brand direction itself.
4. If `.impeccable.md` or loaded instructions do not already provide design context, run `/impeccable teach` before design work.
5. Do not use `/polish` too early. It is a final pass, not a substitute for structure.
6. Do not spawn subagents unless the user explicitly asks for parallel agents, bigbots, delegation, or a distributed review.
7. If the user explicitly asks for three bigbots, fill exactly 3 GPT-5.5 medium research roles and keep the main agent responsible for synthesis.

## Decision Flow

### 1. No design context yet

Use `/impeccable teach`.

Choose this when:

- the repo has no `.impeccable.md`
- target audience or brand tone is still unclear
- the user has not defined what the interface should feel like
- a future design command would otherwise be guessing

Expected outcome:

- project design context written into `.impeccable.md`
- clear users, tone, anti-references, theme direction, and principles

### 2. Starting fresh, but direction is still vague

Use `/shape`.

Choose this when:

- the user wants a new landing page, feature, or UI direction
- you need to turn a fuzzy brief into a sharper design brief
- the right visual direction is not locked yet

Expected outcome:

- a recommended visual direction
- clearer constraints
- enough specificity to move into implementation or critique

### 3. The UI exists, but you do not trust it

Use `/critique` and/or `/audit`.

Choose `/critique` when:

- you want UX and hierarchy feedback
- you need a human-feeling design review
- the page feels off but the failure mode is not yet named

Choose `/audit` when:

- you want structured checks across accessibility, performance, theming, consistency, or responsiveness
- you need a systematic issue list before changing code
- you want evidence, not vibes

Default move:

```text
If the problem is vague, start with /critique.
If the problem needs a checklist and severity, add /audit.
Do both when the page feels AI-generated and you want both judgment and structure.
```

### 4. The issue is known and local

Pick one surgical command.

Use:

- `/typeset` for font choice, scale, hierarchy, weight, leading
- `/layout` for spacing, rhythm, grouping, section composition, grid issues
- `/colorize` for weak or muddy palettes
- `/quieter` for overstimulated visuals, too many accents, too much noise
- `/bolder` for timid layouts that need more attitude
- `/distill` for pages with too much stuff
- `/clarify` for weak UX copy, labels, instructions, empty states
- `/adapt` for responsive or context adaptation issues
- `/animate` for purposeful motion
- `/delight` for personality and small moments after the main UX works
- `/overdrive` only when the user explicitly wants something technically ambitious or unusually expressive

### 5. Final mile only

Use finishing commands near the end:

- `/polish` for final quality pass and cleanup
- `/optimize` for UI performance and rendering behavior

Do not use `/polish` to rescue a weak concept, a generic skeleton, or sloppy hierarchy. That is backwards.

## Recommended Sequence

Default sequence for new design work:

1. `/impeccable teach` if context is missing
2. `/shape` if the direction is still fuzzy
3. `/critique` or `/audit` if you need diagnosis before making changes
4. One or more surgical commands to fix the named issue
5. `/polish` at the end
6. `/optimize` if the visual result is good but performance is suspect

## Bigbots Mode

Use this section only when the user explicitly asks for three bigbots, parallel agents, or a distributed design pass.

Fill exactly 3 research roles:

1. Architecture Archaeologist
2. Blind-Spot / Risk Hunter
3. First-Principles Creative Officer

Ask them to evaluate the same target from three different angles:

- whether the page needs `/shape` or already has enough direction
- whether the current page needs `/critique`, `/audit`, or a surgical command
- whether the finish is ready for `/polish` or is still structurally weak

The main agent must synthesize the output into one decision, not paste three raw reports.

Recommended agent asks:

```text
Role 1: Find stale layout habits, generic structure, and removable UI clutter.
Role 2: Find slop risks, weak hierarchy, contrast issues, and fake-complete states.
Role 3: Propose a bolder but still executable direction if current assumptions are dropped.
```

## Quick Use Cases

### Brand new page or feature

```text
Use impeccable-design-workflow.
Decide which Impeccable command should run first for this new page.
```

### Existing page feels AI-generated

```text
Use impeccable-design-workflow.
This page feels like AI slop. Pick the right diagnosis and fix sequence.
```

### Known problem

```text
Use impeccable-design-workflow.
The typography is mush and spacing is dead. Choose the right surgical commands.
```

### Final pass

```text
Use impeccable-design-workflow.
The structure is done. I want the cleanest final pass without over-editing.
```

## Failure Modes

- Skipping `/impeccable teach` when context is missing
- Reaching for `/polish` before naming the real problem
- Using `impeccable.style` as a style template instead of an anti-pattern yardstick
- Running too many surgical commands at once and muddying cause and effect
- Launching bigbots for theater when the user did not ask for parallel work
