# SurrealDB Integration Requirements

Agent-Pay uses SurrealDB as its system of record.

## Storage Tables

The repository implementation must persist to:

- `payment_intent`
- `payer_proof`
- `receiver_acknowledgement`
- `payment_ledger`
- `payment_status_audit`
- `payment_provider`
- `provider_transaction`
- `payment_dispute`
- `escrow_hold`

## Required Atomic Operation

`update_payment_status()` must:

1. Read the current `payment_intent.status`.
2. Update `payment_intent.status`.
3. Update `payment_intent.updated_at`.
4. Insert a `payment_status_audit` record.

These steps should be executed atomically using a SurrealDB transaction or a single query.

## Record ID Convention

Recommended record ids:

- `payment_intent:<payment_id>`
- `payment_ledger:<payment_id>`
- `payer_proof:<proof_id>`
- `receiver_acknowledgement:<ack_id>`

## Monetary Values

Amounts should be stored as `decimal` values in SurrealDB and serialized as strings in Python.

## Implementation Note

Concrete Python repository code should be written only after confirming the exact SurrealDB Python SDK API and version used by the project.
