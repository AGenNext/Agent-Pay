# SurrealDB Repository Implementation Checklist

Related issue: #10

## SDK Verification

- [ ] Confirm the official Python package name.
- [ ] Confirm the pinned package version.
- [ ] Confirm authentication flow (`signin`, `authenticate`, or equivalent).
- [ ] Confirm namespace/database selection API.
- [ ] Confirm CRUD methods (`create`, `select`, `update`, `merge`, `query`).
- [ ] Confirm transaction support.
- [ ] Confirm record-id formatting conventions.
- [ ] Confirm decimal serialization behavior.

## Repository Implementation

- [ ] Implement `SurrealPaymentRepository`.
- [ ] Implement `create_payment_intent()`.
- [ ] Implement `get_payment_intent()`.
- [ ] Implement `create_payment_ledger()`.
- [ ] Implement `create_payer_proof()`.
- [ ] Implement `create_receiver_acknowledgement()`.
- [ ] Implement `update_payment_status()`.

## Atomic Status Update

`update_payment_status()` must:

1. Read current status.
2. Update `payment_intent.status`.
3. Update `payment_intent.updated_at`.
4. Insert `payment_status_audit`.
5. Execute atomically.

## Testing

- [ ] Unit tests with mocked SDK.
- [ ] Integration tests against a real SurrealDB instance.
- [ ] Verify idempotency behavior.
- [ ] Verify audit records are created.
- [ ] Verify rollback on failure.

## API Integration

- [ ] Replace any in-memory persistence.
- [ ] Wire FastAPI endpoints to repository implementation.

## Definition of Done

The repository implementation is complete when all contract methods are implemented, tests pass, and lifecycle services can persist and retrieve payment records from SurrealDB.
