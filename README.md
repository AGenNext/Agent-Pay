# Agent-Pay

Agent-Pay owns payment protocol contracts for AGenNext across human-to-agent, agent-to-human, agent-to-agent, and direct payment flows.

## Decision

Agent-Pay standardizes payment intents, direct payment intents, authorization, lifecycle, settlement records, payer proof, receiver acknowledgement, refunds, disputes, and audit trails.

Agent-Pay supports both:

- provider-mediated payments through real payment apps/providers
- direct payments through platform-native, wallet-native, or protocol-native payment flows

Agent-Pay does not replace regulated payment processors where those are required.

Agent-Platform owns final payment authorization and payment governance.

## Mandatory transaction proof rule

A transaction is not considered valid or complete unless both sides provide evidence:

```txt
payer_proof
  proof submitted by payer that payment was initiated or completed

receiver_acknowledgement
  signed acknowledgement by receiver that payment was received, accepted, or settled
```

Both payer and receiver acknowledgements must be linked to the payment intent and traceable.

## Scope

Agent-Pay owns:

- human-to-agent payment contracts
- agent-to-human payment contracts
- agent-to-agent payment contracts
- direct payment contracts
- payment intent envelopes
- direct payment intent envelopes
- payer proof records
- receiver signed acknowledgement records
- service pricing references
- usage-based payment records
- escrow/hold contracts
- settlement records
- refund/dispute records
- payment audit references
- payment authorization requirements
- payment status lifecycle
- payment provider references

Agent-Pay does not own:

- final platform authority
- wallet credential custody
- identity verification
- runtime execution
- regulated payment custody unless explicitly implemented through approved provider integrations

## Boundary

| Component | Responsibility |
|---|---|
| Agent-Pay | Payment protocol contracts and payment lifecycle records |
| Agent-Platform | Final payment authorization and governance |
| Agent-Wallet | Wallet UX and credential presentation/signing |
| Agent-Identity | DID/VC identity verification |
| Agent-IGA | Payment authorization and entitlement governance |
| Agent-Channel | Human/agent payment communication channels |
| Agent-Traces | Payment lifecycle timeline events |
| Agent-Commerce | Product/commercial model integration |
| Agent-FinOps | Cost/accounting inputs and optimization |

## Payment modes

```txt
human_to_agent
agent_to_human
agent_to_agent
human_to_human
direct_payment
provider_payment
```

## Provider examples

```txt
stripe
paypal
upi
bank_transfer
crypto_wallet
walletconnect
platform_credit
invoice
```

## Direct payment examples

```txt
wallet_to_wallet
agent_wallet_to_agent_wallet
human_wallet_to_agent_wallet
platform_credit_transfer
internal_ledger_transfer
onchain_transaction
payment_channel
```

## Payment lifecycle

```txt
requested
  ↓
authorized
  ↓
payer_proof_submitted
  ↓
receiver_acknowledged
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
proof_missing
acknowledgement_missing
```

## Human-to-agent provider payment flow

```txt
human requests paid agent service
  ↓
Agent-Pay creates payment intent
  ↓
Agent-Channel presents payment request
  ↓
human completes payment through external payment app/provider
  ↓
payer proof is submitted or provider proof is attached
  ↓
agent/platform receiver signs acknowledgement
  ↓
Agent-Platform authorizes work if payment policy passes
  ↓
Agent-Runtime executes approved work
```

## Direct payment flow

```txt
human or agent requests direct payment
  ↓
Agent-Pay creates direct payment intent
  ↓
Agent-Identity verifies parties
  ↓
Agent-IGA checks authority and limits
  ↓
Agent-Platform authorizes or rejects
  ↓
Agent-Wallet or direct payment rail signs/executes payment
  ↓
payer submits proof
  ↓
receiver signs acknowledgement
  ↓
Agent-Pay records settlement/reconciliation
```

## Agent-to-agent payment flow

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
payer agent submits payment proof
  ↓
receiver agent signs acknowledgement
  ↓
work executes only if payment policy passes
  ↓
Agent-Pay records settlement/reconciliation
```

## Rule

Agents cannot self-authorize payments.

Agent-Pay records payment state.

External payment apps/providers execute provider-mediated payment transactions.

Direct payment rails must still pass Identity, IGA, and Platform authorization.

No transaction is complete without payer proof and receiver signed acknowledgement.

Agent-Platform governs payment authorization.
