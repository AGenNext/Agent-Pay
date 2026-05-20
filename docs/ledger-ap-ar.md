# Ledger, Accounts Payable, and Accounts Receivable

Agent-Pay must track a ledger because payment and delivery of service do not always happen at the same time.

## Decision

Agent-Pay owns payment ledger contracts for:

- accounts payable
- accounts receivable
- payment intents
- delivery obligations
- settlement state
- proof and acknowledgement state
- reconciliation

## Why ledger is required

Payments and services can be asynchronous:

```txt
payment before service
service before payment
partial payment before partial delivery
escrow before acceptance
dispute before settlement
refund after failed delivery
```

So Agent-Pay must not treat a payment event as equivalent to service completion.

## Ledger concepts

| Concept | Meaning |
|---|---|
| Payment Intent | Request or plan to pay |
| Accounts Payable | Amount owed by payer |
| Accounts Receivable | Amount expected by receiver |
| Delivery Obligation | Work/service that must be delivered |
| Payer Proof | Proof submitted by payer |
| Receiver Acknowledgement | Signed acknowledgement by receiver |
| Settlement | Final accounting state |
| Reconciliation | Matching payment, proof, acknowledgement, and delivery |

## States

```txt
payment_requested
payment_authorized
payer_proof_submitted
receivable_open
payable_open
service_pending
service_delivered
receiver_acknowledged
settlement_pending
settled
reconciled
```

Failure/dispute states:

```txt
payment_failed
proof_missing
acknowledgement_missing
service_not_delivered
service_rejected
disputed
refunded
written_off
expired
```

## Rule

A transaction is not complete until all required records are reconciled:

```txt
payment intent
payer proof
receiver acknowledgement
service delivery evidence
accounts payable entry
accounts receivable entry
settlement record
```

## Platform authority

Agent-Platform governs final settlement and dispute decisions.

Agent-Pay records and reconciles financial state.
