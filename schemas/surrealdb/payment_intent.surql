DEFINE TABLE payment_intent SCHEMAFULL;

DEFINE FIELD payer_agent ON TABLE payment_intent TYPE string;
DEFINE FIELD payee_agent ON TABLE payment_intent TYPE string;
DEFINE FIELD workflow_id ON TABLE payment_intent TYPE string;
DEFINE FIELD run_id ON TABLE payment_intent TYPE string;
DEFINE FIELD service_type ON TABLE payment_intent TYPE string;
DEFINE FIELD amount ON TABLE payment_intent TYPE number;
DEFINE FIELD currency ON TABLE payment_intent TYPE string;
DEFINE FIELD status ON TABLE payment_intent TYPE string;
DEFINE FIELD authorization_ref ON TABLE payment_intent FLEXIBLE TYPE option<string>;
DEFINE FIELD settlement_ref ON TABLE payment_intent FLEXIBLE TYPE option<string>;
DEFINE FIELD created_at ON TABLE payment_intent TYPE datetime VALUE time::now();

DEFINE INDEX payment_intent_status_idx ON TABLE payment_intent FIELDS status;
DEFINE INDEX payment_intent_run_idx ON TABLE payment_intent FIELDS run_id;
