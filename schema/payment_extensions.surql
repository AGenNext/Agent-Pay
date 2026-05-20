-- Agent-Pay extension schema

DEFINE TABLE payment_provider SCHEMAFULL;
DEFINE FIELD provider_name ON TABLE payment_provider TYPE string;
DEFINE FIELD provider_type ON TABLE payment_provider TYPE string;
DEFINE FIELD integration_mode ON TABLE payment_provider TYPE string;
DEFINE FIELD public_key_ref ON TABLE payment_provider TYPE option<string>;
DEFINE FIELD secret_key_ref ON TABLE payment_provider TYPE option<string>;
DEFINE FIELD webhook_signing_key_ref ON TABLE payment_provider TYPE option<string>;
DEFINE FIELD status ON TABLE payment_provider TYPE string DEFAULT 'active';
DEFINE FIELD created_at ON TABLE payment_provider TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON TABLE payment_provider TYPE datetime VALUE time::now();
DEFINE FIELD last_verified_at ON TABLE payment_provider TYPE option<datetime>;

DEFINE TABLE provider_transaction SCHEMAFULL;
DEFINE FIELD payment_intent_id ON TABLE provider_transaction TYPE record<payment_intent>;
DEFINE FIELD provider_id ON TABLE provider_transaction TYPE record<payment_provider>;
DEFINE FIELD external_transaction_id ON TABLE provider_transaction TYPE string;
DEFINE FIELD provider_status ON TABLE provider_transaction TYPE string DEFAULT 'pending';
DEFINE FIELD amount ON TABLE provider_transaction TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD currency ON TABLE provider_transaction TYPE string ASSERT string::len($value) = 3;
DEFINE FIELD idempotency_key ON TABLE provider_transaction TYPE string;
DEFINE FIELD provider_payload_hash ON TABLE provider_transaction TYPE option<string>;
DEFINE FIELD provider_payload_ref ON TABLE provider_transaction TYPE option<string>;
DEFINE FIELD verified_at ON TABLE provider_transaction TYPE option<datetime>;
DEFINE FIELD created_at ON TABLE provider_transaction TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON TABLE provider_transaction TYPE datetime VALUE time::now();

DEFINE INDEX provider_txn_external_unique ON TABLE provider_transaction COLUMNS provider_id, external_transaction_id UNIQUE;
DEFINE INDEX provider_txn_idempotency_unique ON TABLE provider_transaction COLUMNS provider_id, idempotency_key UNIQUE;

DEFINE TABLE payment_dispute SCHEMAFULL;
DEFINE FIELD payment_intent_id ON TABLE payment_dispute TYPE record<payment_intent>;
DEFINE FIELD initiated_by ON TABLE payment_dispute TYPE string;
DEFINE FIELD dispute_reason ON TABLE payment_dispute TYPE string;
DEFINE FIELD dispute_status ON TABLE payment_dispute TYPE string DEFAULT 'open';
DEFINE FIELD dispute_evidence_refs ON TABLE payment_dispute TYPE option<array<string>>;
DEFINE FIELD assigned_to ON TABLE payment_dispute TYPE option<string>;
DEFINE FIELD resolution_type ON TABLE payment_dispute TYPE option<string>;
DEFINE FIELD created_at ON TABLE payment_dispute TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON TABLE payment_dispute TYPE datetime VALUE time::now();
DEFINE FIELD resolved_at ON TABLE payment_dispute TYPE option<datetime>;

DEFINE TABLE escrow_hold SCHEMAFULL;
DEFINE FIELD payment_intent_id ON TABLE escrow_hold TYPE record<payment_intent>;
DEFINE FIELD holder_role ON TABLE escrow_hold TYPE string;
DEFINE FIELD amount ON TABLE escrow_hold TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD currency ON TABLE escrow_hold TYPE string ASSERT string::len($value) = 3;
DEFINE FIELD hold_status ON TABLE escrow_hold TYPE string DEFAULT 'created';
DEFINE FIELD release_condition ON TABLE escrow_hold TYPE string;
DEFINE FIELD release_triggered_at ON TABLE escrow_hold TYPE option<datetime>;
DEFINE FIELD released_to ON TABLE escrow_hold TYPE option<string>;
DEFINE FIELD held_at ON TABLE escrow_hold TYPE option<datetime>;
DEFINE FIELD created_at ON TABLE escrow_hold TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at ON TABLE escrow_hold TYPE datetime VALUE time::now();
