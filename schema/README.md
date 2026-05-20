# Agent-Pay Schema

This directory contains the operational SurrealDB schema for Agent-Pay.

## Files

- `payment_core.surql` — payment intents, payer proof, receiver acknowledgement, ledger, and lifecycle audit.
- `payment_extensions.surql` — providers, provider transactions, disputes, and escrow holds.

## Core Guarantees

1. Monetary values use `decimal`.
2. Every payment intent has an `idempotency_key`.
3. No transaction is complete without:
   - `payer_proof`
   - `receiver_acknowledgement`
4. Payment lifecycle states are constrained using `ASSERT`.
5. All major records include `created_at` and `updated_at`.
6. State transitions are captured in `payment_status_audit`.

## Load Order

```bash
surreal import payment_core.surql
surreal import payment_extensions.surql
```

## Next Steps

- Add stored procedures or application services to enforce lifecycle transitions.
- Add webhook ingestion and verification.
- Add reconciliation jobs.
- Add automated tests for disputes, refunds, and chargebacks.
