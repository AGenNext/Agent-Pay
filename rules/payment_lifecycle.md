# Agent-Pay Lifecycle Rules

This document defines the payment lifecycle transition rules that application services must enforce.

## Canonical Lifecycle

```text
requested
→ authorized
→ payer_proof_submitted
→ receiver_acknowledged
→ settled
→ reconciled
```

## Failure States

```text
rejected
cancelled
refunded
disputed
expired
proof_missing
acknowledgement_missing
```

## Transition Rules

| From | To | Required Conditions |
|---|---|---|
| `requested` | `authorized` | Agent-Platform approval exists; payer is not self-authorizing; payment intent has not expired |
| `requested` | `rejected` | Platform, payer, or policy engine rejects request |
| `requested` | `cancelled` | Payer or platform cancels before authorization |
| `authorized` | `payer_proof_submitted` | A `payer_proof` record is linked to the payment intent |
| `payer_proof_submitted` | `receiver_acknowledged` | A `receiver_acknowledgement` record is linked to the payment intent |
| `receiver_acknowledged` | `settled` | Payer proof is verified; receiver acknowledgement is verified; ledger AP/AR state is settled |
| `settled` | `reconciled` | Reconciliation checks pass with no blocking errors |
| Any active state | `expired` | `expires_at` has passed and transaction is not settled |
| Any active state | `disputed` | A dispute is opened by payer, receiver, platform, or provider |
| Any active state | `refunded` | Refund is approved and recorded |

## Hard Invariants

1. Agents cannot self-authorize payments.
2. Work must not execute until payment policy passes.
3. A payment cannot be marked `settled` without verified payer proof and verified receiver acknowledgement.
4. A payment cannot be marked `reconciled` until ledger, provider, proof, and acknowledgement records agree.
5. Every status transition must create a `payment_status_audit` record.
6. Provider-mediated payments must include a `provider_transaction` record before settlement.
7. Direct payments must include verifiable direct-payment proof before settlement.

## Settlement Gate

Settlement is allowed only when:

```text
payment_intent.status = receiver_acknowledged
payer_proof.verification_status = verified
receiver_acknowledgement.verification_status = verified
payment_ledger.payable_status = payable_settled
payment_ledger.receivable_status = receivable_settled
payment_ledger.settlement_status = settlement_pending OR not_started
```

## Reconciliation Gate

Reconciliation is allowed only when:

```text
payment_intent.status = settled
payment_ledger.settlement_status = settled
payment_ledger.reconciliation_status = pending OR not_started
payment_intent.amount = payment_ledger.amount
payment_intent.currency = payment_ledger.currency
payer_proof exists and is verified
receiver_acknowledgement exists and is verified
provider_transaction matches if provider-mediated
```
