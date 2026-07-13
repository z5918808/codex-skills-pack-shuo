---
name: backend-patterns
description: Use when backend design needs a boundary, failure-model, data-consistency, caching, queue, or observability decision.
---

# Backend Patterns

## Core Rule

Add a pattern only when it closes a demonstrated failure mode or isolates a real change boundary. A repository, cache, queue, retry loop, or service layer is not automatically an improvement.

## Start With the Failure Model

Before choosing structure, answer:

1. What state is authoritative, and who may write it?
2. Which operations must be atomic?
3. Which calls cross process, network, or trust boundaries?
4. Can a request, event, job, or webhook arrive twice or out of order?
5. What does timeout mean: failed, succeeded, or unknown?
6. What scale, latency, durability, and recovery targets are real today?
7. What evidence will distinguish before and after?

If these answers are missing, gather evidence before adding architecture.

## Pattern Selection

| Pressure | Smallest useful pattern | Proof |
|---|---|---|
| Business rules mixed with transport | Thin handler plus domain/service function | Rule tests without HTTP |
| Data source likely to change or needs test isolation | Narrow repository or port | One contract test per adapter |
| Multiple writes must succeed together | Database transaction | Fault injection at each write |
| Database state must trigger external work | Transactional outbox | Crash between commit and dispatch |
| Duplicate request or delivery is possible | Idempotency key plus unique constraint | Concurrent duplicate test |
| Slow or bursty durable work | External queue with retry and dead-letter policy | Restart and redelivery test |
| Expensive repeatable reads | Cache-aside with explicit invalidation and tenant-safe keys | Stale-read and isolation test |
| Transient remote failure | Bounded retry with jitter and idempotent operation | Timeout and retry-budget test |
| Partial failure spans services | State machine plus reconciliation | Unknown-state recovery test |
| Operational diagnosis is weak | Structured logs, metrics, traces, correlation ID | Reconstruct one failed request |

Do not add a layer when the direct implementation is already clear, testable, and unlikely to vary.

## Data and API Boundaries

- Keep handlers responsible for transport: parsing, authentication context, status codes, and serialization.
- Keep business invariants independent of HTTP and database client details.
- Validate at the boundary, then enforce critical invariants again with database constraints.
- Select only needed fields and measure queries before adding indexes or caching.
- Treat schema, API, event, and job payload changes as versioned contracts.
- Return stable machine-readable error codes; do not leak stack traces or provider internals.

## Distributed Correctness

- Exactly-once across a database and external provider is usually unavailable. Combine local uniqueness, provider idempotency, and reconciliation.
- Never infer failure from a timeout. Record `unknown` until the same operation can be queried or safely retried.
- Do not call remote services inside a database transaction unless blocking and rollback consequences are explicitly acceptable.
- Make consumers idempotent. Deduplicate webhooks and events with provider or event IDs.
- Prevent stale or out-of-order events from moving state backward.
- Put a bound on retries. Classify permanent, transient, throttled, and unknown outcomes separately.

## Security and Isolation

- Authentication proves identity; authorization checks the specific action and resource.
- Enforce authorization server-side and include tenant scope in every data access path.
- Keep secrets out of source, logs, error bodies, and cache keys.
- Rate limits must work across deployed instances; an in-memory map is only valid for a single-process prototype.
- Log identifiers and outcomes, not credentials, tokens, or sensitive payloads.

## Reject These Defaults

- one repository, service, and controller for every table;
- in-process queues for work that must survive restart;
- retries around non-idempotent writes;
- caches without ownership, invalidation, or tenant isolation;
- broad `catch` blocks that erase failure classes;
- generic “internal error” without a correlation path;
- abstractions justified only by hypothetical future scale;
- happy-path tests without concurrency, duplicate, crash, or timeout cases.

## Verification

Test the failure surface, not only the nominal response:

- concurrent identical requests;
- crash before and after each durable boundary;
- duplicate, delayed, and out-of-order delivery;
- provider success with lost response;
- queue worker restart and redelivery;
- cache invalidation and cross-tenant isolation;
- overload, retry exhaustion, and dead-letter handling;
- logs and metrics sufficient to reconstruct the incident.

Finish only when the selected pattern has a named pressure, a bounded cost, and a rerunnable proof.
