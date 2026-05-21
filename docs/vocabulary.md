# Agent-Pay Vocabulary

This document defines the canonical terms used by Agent-Pay schemas, services, lifecycle rules, and provider integrations.

## Core Objects

| Term | Definition |
|---|---|
| `payment_intent` | A request to initiate, authorize, and track a payment. |
| `direct_payment_intent` | A payment intent executed through platform-native, wallet-native, protocol-native, or on-chain rails. |
| `payment_ledger` | The financial accounting record for payable, receivable, delivery, settlement, and reconciliation state. |
| `payer_proof` | Evidence submitted by the payer showing payment was initiated or completed. |
| `receiver_acknowledgement` | Signed or otherwise verifiable evidence from the receiver that payment was received, accepted, or settled. |
| `provider_transaction` | External payment-provider transaction linked to an Agent-Pay payment intent. |
| `payment_status_audit` | Immutable timeline record for payment status changes. |
| `payment_dispute` | Record of a payment dispute, chargeback, refund request, or remediation case. |
| `escrow_hold` | Record of funds held until release conditions are satisfied. |

## Actors

| Term | Definition |
|---|---|
| `payer` | Party responsible for paying. |
| `receiver` / `payee` | Party expected to receive payment. |
| `platform` | Agent-Platform authority that governs final payment approval. |
| `provider` | External payment processor or rail such as Stripe, PayPal, UPI, bank transfer, or blockchain. |
| `agent` | Autonomous or semi-autonomous software actor participating in a payment flow. |
| `human` | Human user participating in a payment flow. |

## Payment Modes

| Value | Definition |
|---|---|
| `human_to_agent` | Human pays an agent for service, work, tool use, or execution. |
| `agent_to_human` | Agent pays a human. |
| `agent_to_agent` | Agent pays another agent. |
| `human_to_human` | Human pays another human through Agent-Pay orchestration. |
| `direct_payment` | Payment executed through direct rails rather than an external provider app. |
| `provider_payment` | Payment executed through a third-party or regulated payment provider. |

## Payment Intent Status

| Value | Definition |
|---|---|
| `requested` | Payment has been requested but not yet authorized. |
| `authorized` | Payment has passed platform or policy authorization. |
| `payer_proof_submitted` | Payer proof has been attached or submitted. |
| `receiver_acknowledged` | Receiver acknowledgement has been attached or submitted. |
| `settled` | Payment is considered financially settled by Agent-Pay rules. |
| `reconciled` | Payment records have been validated against proof, acknowledgement, provider, ledger, and audit records. |
| `rejected` | Payment request was rejected. |
| `cancelled` | Payment was cancelled before completion. |
| `refunded` | Payment was refunded. |
| `disputed` | Payment is under dispute. |
| `expired` | Payment intent expired before completion. |
| `proof_missing` | Required payer proof is missing. |
| `acknowledgement_missing` | Required receiver acknowledgement is missing. |

## Ledger Status Vocabulary

### Payable Status

| Value | Definition |
|---|---|
| `payable_open` | Payer obligation exists and is not settled. |
| `payable_authorized` | Payer obligation has been authorized. |
| `payable_settled` | Payer obligation has been settled. |
| `payable_cancelled` | Payer obligation was cancelled. |
| `payable_refunded` | Payer obligation was refunded. |

### Receivable Status

| Value | Definition |
|---|---|
| `receivable_open` | Receiver entitlement exists and is not settled. |
| `receivable_expected` | Receiver entitlement is expected based on payment authorization or proof. |
| `receivable_settled` | Receiver entitlement has been settled. |
| `receivable_cancelled` | Receiver entitlement was cancelled. |
| `receivable_refunded` | Receiver entitlement was reversed by refund. |

### Delivery Status

| Value | Definition |
|---|---|
| `service_not_started` | Work or service has not started. |
| `service_pending` | Work or service is in progress. |
| `service_delivered` | Work or service was delivered. |
| `service_failed` | Work or service failed. |
| `service_disputed` | Work or service delivery is disputed. |

### Settlement Status

| Value | Definition |
|---|---|
| `not_started` | Settlement has not begun. |
| `settlement_pending` | Settlement is in progress. |
| `settled` | Settlement has completed. |
| `failed` | Settlement failed. |
| `refunded` | Settlement was reversed by refund. |

### Reconciliation Status

| Value | Definition |
|---|---|
| `not_started` | Reconciliation has not begun. |
| `pending` | Reconciliation is in progress. |
| `reconciled` | Reconciliation has passed. |
| `failed` | Reconciliation failed. |

## Proof Types

| Value | Definition |
|---|---|
| `provider_receipt` | Proof derived from a payment provider receipt. |
| `provider_webhook` | Proof derived from a verified provider webhook. |
| `blockchain_tx` | Proof derived from an on-chain transaction. |
| `signed_message` | Proof derived from a payer-signed message. |
| `bank_reference` | Proof derived from a bank reference number or transfer record. |
| `upi_reference` | Proof derived from a UPI transaction reference. |
| `internal_ledger_entry` | Proof derived from a platform-native internal ledger movement. |

## Receiver Acknowledgement Types

| Value | Definition |
|---|---|
| `signed_receipt` | Receiver signs a receipt confirming payment acceptance. |
| `provider_confirmation` | Provider confirms receiver-side settlement. |
| `platform_acknowledgement` | Platform confirms payment acceptance on behalf of receiver. |
| `wallet_acknowledgement` | Wallet confirms receipt or settlement. |

## Verification Status

| Value | Definition |
|---|---|
| `pending` | Verification has not completed. |
| `verified` | Evidence has been verified. |
| `failed` | Verification failed. |
| `expired` | Evidence expired before verification. |
| `revoked` | Evidence was revoked or invalidated. |

## Provider Types

| Value | Definition |
|---|---|
| `stripe` | Stripe payment provider. |
| `paypal` | PayPal payment provider. |
| `upi` | Unified Payments Interface rail. |
| `bank_transfer` | Bank transfer or wire payment rail. |
| `crypto_wallet` | Crypto wallet payment rail. |
| `walletconnect` | WalletConnect-mediated wallet payment rail. |
| `platform_credit` | Platform-native credit or balance transfer. |
| `invoice` | Invoice-based payment flow. |
| `other` | Other provider or payment rail. |

## Integration Modes

| Value | Definition |
|---|---|
| `api` | Provider is integrated through API calls. |
| `webhook` | Provider sends webhook events. |
| `batch` | Provider settlement is reconciled through batch files or scheduled imports. |
| `manual` | Provider settlement is manually recorded. |
| `internal` | Payment is handled by an internal ledger or platform-native mechanism. |

## Dispute Vocabulary

| Value | Definition |
|---|---|
| `open` | Dispute has been opened. |
| `under_review` | Dispute is being reviewed. |
| `evidence_requested` | More evidence is required. |
| `resolved` | Dispute has been resolved. |
| `escalated` | Dispute has been escalated. |
| `closed` | Dispute has been closed. |

## Escrow Vocabulary

| Value | Definition |
|---|---|
| `created` | Escrow hold record has been created. |
| `held` | Funds are being held. |
| `release_pending` | Release has been requested or triggered. |
| `released` | Funds have been released. |
| `retained` | Funds have been retained after dispute or policy decision. |
| `cancelled` | Hold was cancelled. |
| `disputed` | Hold is disputed. |

## Release Conditions

| Value | Definition |
|---|---|
| `upon_service_delivery` | Release when service delivery is proven. |
| `upon_receiver_acceptance` | Release when receiver accepts or acknowledges. |
| `on_date` | Release on a specified date. |
| `manual_platform_release` | Release manually by platform authority. |
| `dispute_resolution` | Release after dispute resolution. |

## Authorization Rule

Agents cannot self-authorize payments. Agent-Platform or an approved governance component must authorize payment execution.

## Completion Rule

A transaction is not complete unless both `payer_proof` and `receiver_acknowledgement` are linked, traceable, and verified according to Agent-Pay rules.
