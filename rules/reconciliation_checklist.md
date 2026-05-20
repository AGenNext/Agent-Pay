# Agent-Pay Reconciliation Checklist

A payment is considered fully reconciled only when all of the following checks pass.

## Record Presence

- Payment intent exists.
- Payment ledger exists.
- Payer proof exists.
- Receiver acknowledgement exists.
- Status audit entries exist.
- Provider transaction exists if provider-mediated.
- Escrow hold exists if escrow was used.

## Amount Validation

- `payment_intent.amount == payment_ledger.amount`
- `payment_intent.currency == payment_ledger.currency`
- `provider_transaction.amount == payment_intent.amount` (provider-mediated)
- `provider_transaction.currency == payment_intent.currency` (provider-mediated)

## Identity Validation

- Payment intent payer matches ledger payer.
- Payment intent payee matches ledger receiver.
- Proof submitter matches payer.
- Receiver signer matches payee or authorized receiver.

## Verification Validation

- Payer proof verification status is `verified`.
- Receiver acknowledgement verification status is `verified`.
- Provider transaction is verified if provider-mediated.

## Status Validation

- Payment intent status is `settled` before reconciliation.
- Ledger settlement status is `settled`.
- Payable status is `payable_settled`.
- Receivable status is `receivable_settled`.

## Dispute Validation

- No open dispute exists.
- No unresolved provider chargeback exists.

## Escrow Validation

- Any escrow hold has been released or appropriately retained.

## Audit Validation

- All status transitions are present in `payment_status_audit`.
- Timestamps are monotonic.

## Final Rule

Only after every check passes may:

```text
payment_intent.status = reconciled
payment_ledger.reconciliation_status = reconciled
```
