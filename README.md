# Agent-Pay

Agent-Pay owns agent-to-agent payment protocol contracts for AGenNext.

## Decision

Agent-Pay implements the A2A payment layer for agents, agent teams, tools, services, and platform-mediated work.

Agent-Platform owns final payment authorization and settlement policy.

Agent-Pay defines payment requests, payment intents, escrow/hold records, settlement records, refunds, disputes, and audit trails.

## Scope

Agent-Pay owns:

- agent-to-agent payment protocol contracts
- payment intent envelopes
- service pricing references
- usage-based payment records
- escrow/hold contracts
- settlement records
- refund/dispute records
- payment audit references
- payment authorization requirements
- payment status lifecycle

Agent-Pay does not own:

- final platform authority
- wallet credential custody
- identity verification
- runtime execution
- fiat/crypto custody implementation unless explicitly added later

## Boundary

| Component | Responsibility |
|---|---|
| Agent-Pay | A2A payment protocol contracts and payment lifecycle records |
| Agent-Platform | Final payment authorization and governance |
| Agent-Wallet | Wallet UX and credential presentation/signing |
| Agent-Identity | DID/VC identity verification |
| Agent-IGA | Payment authorization and entitlement governance |
| Agent-Traces | Payment lifecycle timeline events |
| Agent-Commerce | Product/commercial model integration |
| Agent-FinOps | Cost/accounting inputs and optimization |

## Payment lifecycle

```txt
requested
  ↓
authorized
  ↓
held_or_escrowed
  ↓
settled
  ↓
reconciled
```

Failure paths:

```txt
rejected
cancelled
refunded
disputed
expired
```

## A2A payment flow

```txt
agent requests paid service/tool/work
  ↓
Agent-Pay creates payment intent
  ↓
Agent-Identity verifies parties
  ↓
Agent-IGA checks payment authority
  ↓
Agent-Platform approves or rejects payment
  ↓
work executes only if payment policy passes
  ↓
Agent-Pay records settlement/reconciliation
```

## Rule

Agents cannot self-authorize payments.

Agent-Pay records payment state.

Agent-Platform governs payment authorization.
