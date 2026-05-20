-- Agent-Pay core operational schema
-- Defines durable payment intent, ledger, proof, acknowledgement, and audit records.

DEFINE TABLE payment_intent SCHEMAFULL;

DEFINE FIELD payer_agent ON TABLE payment_intent TYPE string;
DEFINE FIELD payee_agent ON TABLE payment_intent TYPE string;
DEFINE FIELD workflow_id ON TABLE payment_intent TYPE option<string>;
DEFINE FIELD run_id ON TABLE payment_intent TYPE option<string>;
DEFINE FIELD payment_mode ON TABLE payment_intent TYPE string ASSERT $value IN [
  'human_to_agent',
  'agent_to_human',
  'agent_to_agent',
  'human_to_human',
  'direct_payment',
  'provider_payment'
];
DEFINE FIELD service_type ON TABLE payment_intent TYPE option<string>;
DEFINE FIELD amount ON TABLE payment_intent TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD currency ON TABLE payment_intent TYPE string ASSERT string::len($value) = 3;
DEFINE FIELD status ON TABLE payment_intent TYPE string DEFAULT 'requested' ASSERT $value IN [
  'requested',
  'authorized',
  'payer_proof_submitted',
  'receiver_acknowledged',
  'settled',
  'reconciled',
  'rejected',
  'cancelled',
  'refunded',
  'disputed',
  'expired',
  'proof_missing',
  'acknowledgement_missing'
];
DEFINE FIELD authorization_ref ON TABLE payment_intent TYPE option<string>;
DEFINE FIELD authorized_by ON TABLE payment_intent TYPE option<string>;
DEFINE FIELD authorized_at ON TABLE payment_intent TYPE option<datetime>;
DEFINE FIELD authorization_reason ON TABLE payment_intent TYPE option<string>;
DEFINE FIELD idempotency_key ON TABLE payment_intent TYPE string;
DEFINE FIELD expires_at ON TABLE payment_intent TYPE option<datetime>;
DEFINE FIELD metadata ON TABLE payment_intent TYPE option<object>;
DEFINE FIELD created_by ON TABLE payment_intent TYPE string;
DEFINE FIELD created_at ON TABLE payment_intent TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON TABLE payment_intent TYPE datetime VALUE time::now();

DEFINE INDEX payment_intent_status_idx ON TABLE payment_intent COLUMNS status;
DEFINE INDEX payment_intent_run_idx ON TABLE payment_intent COLUMNS run_id;
DEFINE INDEX payment_intent_payer_idx ON TABLE payment_intent COLUMNS payer_agent;
DEFINE INDEX payment_intent_payee_idx ON TABLE payment_intent COLUMNS payee_agent;
DEFINE INDEX payment_intent_idempotency_unique ON TABLE payment_intent COLUMNS idempotency_key UNIQUE;

DEFINE TABLE payer_proof SCHEMAFULL;

DEFINE FIELD payment_intent_id ON TABLE payer_proof TYPE record<payment_intent>;
DEFINE FIELD proof_type ON TABLE payer_proof TYPE string ASSERT $value IN [
  'provider_receipt',
  'provider_webhook',
  'blockchain_tx',
  'signed_message',
  'bank_reference',
  'upi_reference',
  'internal_ledger_entry'
];
DEFINE FIELD proof_payload_hash ON TABLE payer_proof TYPE string;
DEFINE FIELD proof_payload_ref ON TABLE payer_proof TYPE option<string>;
DEFINE FIELD external_reference ON TABLE payer_proof TYPE option<string>;
DEFINE FIELD submitted_by ON TABLE payer_proof TYPE string;
DEFINE FIELD submitted_at ON TABLE payer_proof TYPE datetime DEFAULT time::now();
DEFINE FIELD verification_method ON TABLE payer_proof TYPE option<string>;
DEFINE FIELD verification_status ON TABLE payer_proof TYPE string DEFAULT 'pending' ASSERT $value IN [
  'pending',
  'verified',
  'failed',
  'expired',
  'revoked'
];
DEFINE FIELD verified_at ON TABLE payer_proof TYPE option<datetime>;
DEFINE FIELD expires_at ON TABLE payer_proof TYPE option<datetime>;
DEFINE FIELD created_at ON TABLE payer_proof TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON TABLE payer_proof TYPE datetime VALUE time::now();

DEFINE INDEX payer_proof_intent_idx ON TABLE payer_proof COLUMNS payment_intent_id;
DEFINE INDEX payer_proof_status_idx ON TABLE payer_proof COLUMNS verification_status;

DEFINE TABLE receiver_acknowledgement SCHEMAFULL;

DEFINE FIELD payment_intent_id ON TABLE receiver_acknowledgement TYPE record<payment_intent>;
DEFINE FIELD ack_type ON TABLE receiver_acknowledgement TYPE string ASSERT $value IN [
  'signed_receipt',
  'provider_confirmation',
  'platform_acknowledgement',
  'wallet_acknowledgement'
];
DEFINE FIELD ack_payload_hash ON TABLE receiver_acknowledgement TYPE string;
DEFINE FIELD ack_signature ON TABLE receiver_acknowledgement TYPE option<string>;
DEFINE FIELD signature_algorithm ON TABLE receiver_acknowledgement TYPE option<string>;
DEFINE FIELD signed_by ON TABLE receiver_acknowledgement TYPE string;
DEFINE FIELD signed_at ON TABLE receiver_acknowledgement TYPE datetime DEFAULT time::now();
DEFINE FIELD verification_method ON TABLE receiver_acknowledgement TYPE option<string>;
DEFINE FIELD verification_status ON TABLE receiver_acknowledgement TYPE string DEFAULT 'pending' ASSERT $value IN [
  'pending',
  'verified',
  'failed',
  'revoked'
];
DEFINE FIELD verified_at ON TABLE receiver_acknowledgement TYPE option<datetime>;
DEFINE FIELD created_at ON TABLE receiver_acknowledgement TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON TABLE receiver_acknowledgement TYPE datetime VALUE time::now();

DEFINE INDEX receiver_ack_intent_idx ON TABLE receiver_acknowledgement COLUMNS payment_intent_id;
DEFINE INDEX receiver_ack_status_idx ON TABLE receiver_acknowledgement COLUMNS verification_status;

DEFINE TABLE payment_ledger SCHEMAFULL;

DEFINE FIELD payment_intent_id ON TABLE payment_ledger TYPE record<payment_intent>;
DEFINE FIELD payer ON TABLE payment_ledger TYPE string;
DEFINE FIELD receiver ON TABLE payment_ledger TYPE string;
DEFINE FIELD amount ON TABLE payment_ledger TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD currency ON TABLE payment_ledger TYPE string ASSERT string::len($value) = 3;
DEFINE FIELD payable_status ON TABLE payment_ledger TYPE string DEFAULT 'payable_open' ASSERT $value IN [
  'payable_open',
  'payable_authorized',
  'payable_settled',
  'payable_cancelled',
  'payable_refunded'
];
DEFINE FIELD receivable_status ON TABLE payment_ledger TYPE string DEFAULT 'receivable_open' ASSERT $value IN [
  'receivable_open',
  'receivable_expected',
  'receivable_settled',
  'receivable_cancelled',
  'receivable_refunded'
];
DEFINE FIELD delivery_status ON TABLE payment_ledger TYPE string DEFAULT 'service_not_started' ASSERT $value IN [
  'service_not_started',
  'service_pending',
  'service_delivered',
  'service_failed',
  'service_disputed'
];
DEFINE FIELD settlement_status ON TABLE payment_ledger TYPE string DEFAULT 'not_started' ASSERT $value IN [
  'not_started',
  'settlement_pending',
  'settled',
  'failed',
  'refunded'
];
DEFINE FIELD reconciliation_status ON TABLE payment_ledger TYPE string DEFAULT 'not_started' ASSERT $value IN [
  'not_started',
  'pending',
  'reconciled',
  'failed'
];
DEFINE FIELD payer_proof_ref ON TABLE payment_ledger TYPE option<record<payer_proof>>;
DEFINE FIELD receiver_ack_ref ON TABLE payment_ledger TYPE option<record<receiver_acknowledgement>>;
DEFINE FIELD delivery_evidence_ref ON TABLE payment_ledger TYPE option<string>;
DEFINE FIELD provider_transaction_ref ON TABLE payment_ledger TYPE option<record<provider_transaction>>;
DEFINE FIELD dispute_status ON TABLE payment_ledger TYPE option<string>;
DEFINE FIELD reconciliation_errors ON TABLE payment_ledger TYPE option<array<string>>;
DEFINE FIELD transaction_date ON TABLE payment_ledger TYPE option<datetime>;
DEFINE FIELD settlement_date ON TABLE payment_ledger TYPE option<datetime>;
DEFINE FIELD created_at ON TABLE payment_ledger TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON TABLE payment_ledger TYPE datetime VALUE time::now();

DEFINE INDEX payment_ledger_intent_idx ON TABLE payment_ledger COLUMNS payment_intent_id;
DEFINE INDEX payment_ledger_payer_idx ON TABLE payment_ledger COLUMNS payer;
DEFINE INDEX payment_ledger_receiver_idx ON TABLE payment_ledger COLUMNS receiver;
DEFINE INDEX payment_ledger_settlement_idx ON TABLE payment_ledger COLUMNS settlement_status;

DEFINE TABLE payment_status_audit SCHEMAFULL;

DEFINE FIELD payment_intent_id ON TABLE payment_status_audit TYPE record<payment_intent>;
DEFINE FIELD old_status ON TABLE payment_status_audit TYPE option<string>;
DEFINE FIELD new_status ON TABLE payment_status_audit TYPE string;
DEFINE FIELD changed_by ON TABLE payment_status_audit TYPE string;
DEFINE FIELD changed_by_role ON TABLE payment_status_audit TYPE string ASSERT $value IN [
  'payer',
  'receiver',
  'platform',
  'provider',
  'system'
];
DEFINE FIELD reason ON TABLE payment_status_audit TYPE option<string>;
DEFINE FIELD evidence_ref ON TABLE payment_status_audit TYPE option<string>;
DEFINE FIELD created_at ON TABLE payment_status_audit TYPE datetime DEFAULT time::now();

DEFINE INDEX payment_status_audit_intent_idx ON TABLE payment_status_audit COLUMNS payment_intent_id;
DEFINE INDEX payment_status_audit_created_idx ON TABLE payment_status_audit COLUMNS created_at;
