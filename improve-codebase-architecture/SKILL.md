---
name: improve-codebase-architecture
description: "Use when the user wants to treat any project as a system and inspect its architecture: codebases, workflows, docs, automations, content pipelines, operations, data flows, product processes, or skill systems. Finds friction, shallow modules, unclear interfaces, scattered ownership, weak verification, and deepening opportunities."
---

# Improve System Architecture

Use this skill to inspect any project as a system, not only a codebase.

The goal is to find architecture friction and propose **deepening opportunities**: changes that put more useful behavior behind clearer interfaces, concentrate ownership, improve verification, and make the project easier for humans and agents to navigate.

Do not jump straight to refactoring. First understand the system.

## What Counts As A System

A system can be:

- source code and modules
- a product workflow
- a research or content pipeline
- a business operation
- a documentation set
- an automation stack
- an AI-agent workflow
- a skill library
- a dataset / reporting process
- a team handoff process

If it has inputs, outputs, decisions, states, ownership, failure modes, and verification, it has architecture.

## Core Vocabulary

Use these terms consistently:

- **Module** — any unit with an interface and implementation: file, function, workflow step, document, report, automation, role, checklist, queue, dashboard, or handoff.
- **Interface** — what another person, agent, process, or module must know to use it: inputs, outputs, assumptions, invariants, error modes, ordering, permissions, state, and expected evidence.
- **Implementation** — the hidden work inside the module: code, human steps, scripts, prompts, data transforms, review rules, or operational procedure.
- **Depth** — how much useful behavior sits behind a small, stable interface.
- **Shallow module** — a module whose interface is nearly as complex as its implementation, or whose callers must understand too much internal detail.
- **Ownership** — who or what is responsible for keeping the module correct.
- **Locality** — whether related knowledge, change, bugs, and verification live close together.
- **Leverage** — what the system gains when this module becomes deeper or clearer.
- **Verification surface** — the smallest evidence needed to prove the module still works.

## Architecture Smells

Look for:

- understanding one concept requires bouncing across many files, docs, prompts, people, or tools
- a step exists only as pass-through ceremony
- important state lives only in chat, memory, or tribal knowledge
- the same decision is repeated in multiple places
- a workflow cannot be verified except by manually replaying everything
- agents need too much context before they can act
- ownership is split in a way that creates blame gaps
- a document says one thing but tools or live outputs say another
- exception handling dominates the mainline
- the system has no clear stop gate, recovery path, or done evidence
- small changes require touching many unrelated places

## Deletion Test

For any suspected shallow module, ask:

- If this module disappeared, would complexity disappear?
- Or would the same complexity reappear across many callers, docs, prompts, or human steps?

If deleting it just removes ceremony, it is probably shallow.

If deleting it spreads complexity everywhere, it may deserve to become deeper, clearer, or more explicitly owned.

## Process

### 1. Map The System

Start from live truth:

- repo files, docs, scripts, logs, dashboards, reports, prompts, checklists, tickets, diagrams, or terminal output
- existing `CONTEXT.md`, ADRs, `_ctx`, status files, handoffs, project memory, or user-provided constraints
- current user goal and what "done" means

Create a compact mental map:

- inputs
- outputs
- mainline flow
- decision points
- state ownership
- module boundaries
- verification points
- failure / recovery points

Do not treat old summaries as truth if live artifacts contradict them.

### 2. Find Deepening Opportunities

Surface a numbered list of opportunities. For each:

- **Area** — files, docs, workflow steps, artifacts, prompts, roles, or tools involved
- **Friction** — what currently makes the system hard to understand, change, verify, or hand off
- **Current interface** — what users, agents, or callers must know today
- **Deepening move** — what would be concentrated, renamed, extracted, documented, automated, or given a clearer interface
- **Benefit** — locality, leverage, testability, auditability, agent navigability, reduced handoff cost, or clearer recovery
- **Verification** — how to prove the improvement worked
- **Risk** — what could be broken, oversimplified, or moved to the wrong place

Do not propose every theoretical improvement. Pick the highest-leverage 3-7 candidates.

### 3. Respect Existing Decisions

Before proposing change, check whether the project already has:

- ADRs
- standards
- design docs
- workflow docs
- `_ctx` memory
- `CONTEXT.md`
- user-stated constraints

If a candidate contradicts an existing decision, surface it only when the friction is real enough to revisit the decision. Mark the conflict clearly.

### 4. Choose Before Designing

After presenting candidates, ask which one to explore first.

Do not jump into full implementation design unless the user asks. The first output should make the architectural options visible.

When the user picks one candidate, walk the design tree:

- what interface should exist?
- what should be hidden behind it?
- who or what owns it?
- what state and invariants matter?
- what verification proves it?
- what migration path avoids breaking the mainline?
- what should be documented or archived so the system stays understandable?

## Output Shape

Use Traditional Chinese unless the project vocabulary is already English.

```text
目前判斷：
[系統主線與最大架構摩擦。進度 X%。]

系統地圖：
- Inputs:
- Outputs:
- Mainline:
- Ownership / state:
- Verification:

Deepening opportunities：
1. [候選名稱]
   Area:
   Friction:
   Current interface:
   Deepening move:
   Benefit:
   Verification:
   Risk:

建議先探索：
[一個最高槓桿候選與理由。]

下一步：
[問使用者要探索哪個候選，或在使用者已指定時進入設計樹。]
```

## Hard Rules

- Do not assume architecture means code.
- Do not rename every problem into "module" if the project already has better domain vocabulary.
- Do not propose broad reorgs without explaining verification and migration.
- Do not optimize for elegance over mainline progress.
- Do not bury the user in theory; show concrete friction and concrete leverage.
- Do not edit project files unless the user asks to implement, document, or record a decision.
- If the task touches production, database, money, orders, inventory, customer data, credentials, or destructive operations, switch to the relevant safety workflow first.
