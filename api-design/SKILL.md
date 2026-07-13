---
name: api-design
description: Use when designing or reviewing REST API resources, semantics, errors, pagination, idempotency, or evolution.
---

# API Design

## Core Rule

Design from the consumer’s job, state model, and failure behavior. URL style and response envelopes are secondary to a coherent, evolvable contract.

Match the existing API unless a change is explicitly justified. Do not impose plural nouns, kebab-case, envelopes, URL versioning, or cursor pagination as universal rules.

## Contract First

For each operation define:

- consumer intent and resource or action;
- authentication, authorization, and tenant scope;
- request schema, defaults, limits, and unknown-field policy;
- response schema and observable state transitions;
- idempotency and concurrency behavior;
- errors, retryability, timeout meaning, and rate limits;
- pagination, ordering, filtering, and consistency model;
- compatibility, deprecation, and retention policy;
- examples and a machine-readable source of truth when the project uses one.

If these decisions are unclear, writing handler code is premature.

## HTTP Semantics

- Use safe and idempotent methods according to their real server behavior, not only their names.
- Use `201` when a resource is created synchronously and expose its location when useful.
- Use `202` when work was accepted but is not complete; provide a status resource and polling guidance.
- Use `204` only when a response body adds no value.
- Distinguish unauthenticated (`401`) from authenticated but forbidden (`403`) according to the API’s disclosure policy.
- Use `404` when absence or intentional non-disclosure is the contract.
- Use `409` for current-state or idempotency conflicts; use `422` only when the project consistently distinguishes semantic validation.
- Use `429` or temporary service errors with bounded retry guidance when clients can act on it.

The exact code matters less than consistency, documentation, and client recovery behavior.

## Idempotency and Concurrency

- Require an idempotency key for retried operations with side effects when duplicates are costly.
- Scope the key, store a request fingerprint, define its retention, and reject key reuse with different input.
- Specify conditional updates, version fields, or ETags when lost updates matter.
- Treat remote timeouts as unknown when the operation may have succeeded.
- Define cancellation and terminal-state races explicitly.

## Errors

Return stable machine-readable codes plus safe human messages. Include field details and a correlation ID when useful.

Do not expose stack traces, SQL, provider bodies, secrets, or object existence across an authorization boundary. Preserve richer internal evidence in protected logs.

Classify errors so clients know whether to fix input, reauthenticate, wait, retry safely, reconcile, or stop.

## Collections

- Define a stable total order with a tie-breaker.
- Choose offset pagination when page-number navigation and bounded data make it useful.
- Choose cursor pagination when stable incremental traversal and large or changing data matter.
- Bind opaque cursors to relevant filters, order, and tenant scope.
- Define maximum page size, filter grammar, sortable fields, and behavior for invalid or expired cursors.
- Do not promise totals when computing them is expensive or inconsistent.

## Security and Operations

- Derive tenant and identity from trusted authentication context, not request fields.
- Recheck object-level authorization on read, mutation, cancellation, and download.
- Apply rate and quota policy at a shared enforcement point; do not publish invented limits.
- Keep signed URLs short-lived and out of logs.
- Audit sensitive state changes with request and resource identifiers.

## Evolution

- Prefer additive compatible changes and require clients to ignore unknown response fields when that is the contract.
- Do not assume adding a field is safe if schemas reject unknowns or signatures include the body.
- Version only when a breaking behavior cannot be evolved compatibly.
- Publish deprecation and sunset evidence before removal.
- Keep the machine-readable specification, implementation, examples, and contract tests synchronized.

## Verification

Test the contract from a client’s view:

- valid, invalid, unauthorized, forbidden, absent, conflict, throttled, and provider-failure cases;
- duplicate and concurrent requests;
- timeout after a side effect and safe replay;
- pagination under inserts, deletes, and repeated cursors;
- cancellation and terminal-state races;
- cross-tenant probing and data leakage;
- old client behavior against additive changes;
- documentation or schema examples against the real implementation.

Finish only when clients can determine what happened, what is safe to do next, and how the contract may evolve.
