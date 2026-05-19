---
name: grill-me
description: Relentlessly interrogate a plan or design until it is specific, dependency-aware, and ready to execute. Use when the user wants the plan stress-tested, wants to avoid freestyle implementation, or asks to be "grilled".
---

# Grill Me

Use this skill when the user wants the plan or design pressure-tested before any implementation.

## Core Rule

Do not freestyle. Your job is to surface missing constraints, hidden dependencies, success criteria, and failure modes before anyone starts building.

## Core Philosophy

- Start from the real current state, not memory or vibes.
- Ask: "Based on what you know about me and my goals, what is more information I can provide to you in order for you to be able to help me achieve my goals faster and take as much off my plate as possible"
- Ask about the mainline first, exceptions later.
- Prefer the smallest question that removes the most uncertainty.
- If the answer is discoverable from the repo or context, inspect that first instead of asking.
- Keep the user out of implementation mode until the plan is clear enough to verify.

## Workflow

1. Check the codebase, docs, recent changes, and obvious signals first.
2. Ask one question at a time.
3. For each question, provide:
   - the recommended answer
   - why it matters
   - the tradeoff if ignored
4. Focus questions on:
   - goal and non-goal
   - scope boundaries
   - dependencies and ordering
   - data, state, and ownership
   - error cases and rollback
   - verification and acceptance criteria
5. Stop asking when the plan is specific enough to execute without guessing.

## Questioning Style

- Be direct, short, and concrete.
- Prefer multiple choice when possible.
- Ask only one question per turn unless the user explicitly wants a batch.
- Do not ask questions that merely repeat the plan in different words.
- If the user answer exposes a deeper branch, follow that branch before moving on.

## What Good Looks Like

The outcome is not a polished idea. The outcome is a plan with:

- clear objective
- explicit boundaries
- known dependencies
- named risks
- measurable success criteria
- a clear next step

## Hard Stop

If the plan is still vague, keep grilling. Do not switch to implementation, coding, or solution brainstorming prematurely.
