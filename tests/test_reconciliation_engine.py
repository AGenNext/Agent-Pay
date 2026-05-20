from src.reconciliation_engine import ReconciliationEngine, ReconciliationInput


def base_input() -> ReconciliationInput:
    return ReconciliationInput(
        payment_intent_status='settled',
        payment_intent_amount='10.00',
        payment_intent_currency='USD',
        ledger_settlement_status='settled',
        ledger_reconciliation_status='pending',
        ledger_amount='10.00',
        ledger_currency='USD',
        payable_status='payable_settled',
        receivable_status='receivable_settled',
        payer_proof_status='verified',
        receiver_ack_status='verified',
    )


def test_reconciliation_passes():
    engine = ReconciliationEngine()
    result = engine.validate(base_input())
    assert result.passed is True
    assert result.errors == []


def test_fails_on_amount_mismatch():
    engine = ReconciliationEngine()
    data = base_input()
    data.ledger_amount = '11.00'
    result = engine.validate(data)
    assert result.passed is False
    assert any('amount' in error for error in result.errors)


def test_fails_with_open_dispute():
    engine = ReconciliationEngine()
    data = base_input()
    data.open_dispute = True
    result = engine.validate(data)
    assert result.passed is False
    assert any('open dispute' in error for error in result.errors)
