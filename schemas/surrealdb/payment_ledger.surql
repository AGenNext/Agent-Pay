DEFINE TABLE payment_ledger SCHEMAFULL;

DEFINE FIELD payment_intent_id ON TABLE payment_ledger TYPE string;
DEFINE FIELD payer ON TABLE payment_ledger TYPE string;
DEFINE FIELD receiver ON TABLE payment_ledger TYPE string;
DEFINE FIELD amount ON TABLE payment_ledger TYPE number;
DEFINE FIELD currency ON TABLE payment_ledger TYPE string;
DEFINE FIELD payable_status ON TABLE payment_ledger TYPE string;
DEFINE FIELD receivable_status ON TABLE payment_ledger TYPE string;
DEFINE FIELD delivery_status ON TABLE payment_ledger TYPE string;
DEFINE FIELD payer_proof_ref ON TABLE payment_ledger FLEXIBLE TYPE option<string>;
DEFINE FIELD receiver_ack_ref ON TABLE payment_ledger FLEXIBLE TYPE option<string>;
DEFINE FIELD delivery_evidence_ref ON TABLE payment_ledger FLEXIBLE TYPE option<string>;
DEFINE FIELD settlement_status ON TABLE payment_ledger TYPE string;
DEFINE FIELD reconciliation_status ON TABLE payment_ledger TYPE string;
DEFINE FIELD created_at ON TABLE payment_ledger TYPE datetime VALUE time::now();

DEFINE INDEX payment_ledger_settlement_idx ON TABLE payment_ledger FIELDS settlement_status;
DEFINE INDEX payment_ledger_reconciliation_idx ON TABLE payment_ledger FIELDS reconciliation_status;
