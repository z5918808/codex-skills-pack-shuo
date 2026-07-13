---
name: report-for-outsourcing
description: Use when the user asks for report-out, outsourcing, external review, 問外部, or a zero-context packet for an analyst.
---

# Report for Outsourcing

## Purpose

Produce one self-contained Markdown decision packet for an external AI or human who cannot access local files, repo state, terminal, browser, prior chat, credentials, or hidden instructions.

Use only when the user explicitly wants outside review. Ordinary explanations and internal repo review do not trigger this skill.

## Safety Gate

Before writing:

- redact tokens, keys, passwords, cookies, sessions, signed URLs, private endpoints, customer data, orders, payment data, and unnecessary production identifiers;
- preserve useful non-secret status, error codes, timestamps, run IDs, hashes, and header names;
- keep the raw source local and unchanged;
- use the minimum disclosure that still permits the requested decision;
- stop for user confirmation when the packet would expose sensitive business, customer, financial, legal, or production information beyond the stated scope.

Never turn a redacted packet into permission for live action.

## Choose One Primary Report Kind

| Kind | Decision focus |
|---|---|
| Operator / control room | current truth, owner, permission boundary, one next decision |
| Architecture / design | system boundaries, ownership, interfaces, risks, next milestone |
| Bug / blocker | expected vs actual, reproduction, evidence, narrowed cause, next probe |
| Code review | changed surface, intent, findings, tests, unresolved risk |
| Research / strategy | decision criteria, sourced options, uncertainty, recommendation |

Do not mix several primary roles. Put secondary material in a short appendix.

## Build the Packet

1. Write the external reviewer’s role and what is explicitly not requested.
2. State one `Decision Needed` sentence.
3. Reconstruct only the context required to decide.
4. Separate verified fact, source claim, inference, and unknown.
5. Attach small evidence excerpts with stable IDs and coordinates.
6. State authority, safety, scope, and non-goals.
7. Turn missing decision-critical evidence into `Blocking Unknowns`.
8. Ask three to seven questions that can be answered from the packet.
9. Specify the desired output shape.
10. Check that the reviewer never needs local access to begin.

## Evidence Discipline

Use a compact table:

| ID | Type | Claim | Coordinate | Limitation |
|---|---|---|---|---|
| E1 | verified fact / source claim / inference | ... | path, line, command, run ID, URL | ... |

- A tool result, executor report, HTTP 200, green test, or AI output is a claim until its relevant evidence is checked.
- Identify artifacts by path plus run ID or hash when freshness matters; never use mtime-latest as truth.
- Normalize comparable data before diffing.
- Quote only the lines needed for the decision and explain why each excerpt matters.
- If evidence conflicts, surface the conflict instead of averaging it into a confident summary.

## Operator Packet Additions

Include:

- current accepted truth and active owner;
- exact boundary: read-only, local write, staging, live, production, data, money, or destructive;
- permission currently granted and explicitly not granted;
- one next operator decision;
- signals that must not be reinterpreted, such as dry-run, no-send, selected candidate, or readiness green;
- exact gate that would allow the boundary to move.

Engineering hardening ideas remain non-actionable unless the user asked for architecture work.

## Architecture Packet Additions

Include the entrypoints, main data or control flow, state owners, interfaces, external dependencies, failure handling, current milestone, unfinished work, and risk register. Do not ask the reviewer to infer architecture from filenames alone.

## Packet Shape

```markdown
# <Decision Packet Title>

## Reviewer Role and Boundaries
## Decision Needed
## Zero-Context Background
## Current Truth
## Constraints and Non-Goals
## Evidence Index
## Blocking Unknowns
## Risks and Decision Boundary
## Questions for the Reviewer
## Requested Output
## Appendix (only if needed)
```

Write normal Markdown, not one giant fenced block, unless the user explicitly asks for `cb`. If the user asks for a file, save one `.md` packet and return its path.

## Final Check

The packet is ready only when:

- secrets and unnecessary sensitive data are removed;
- the first screen makes the reviewer role and decision clear;
- facts, claims, inferences, and unknowns are distinguishable;
- every important claim has a coordinate or is marked unsupported;
- the authority and live boundary cannot be mistaken;
- the questions are answerable without local access;
- the packet is concise enough that each section changes the decision.
