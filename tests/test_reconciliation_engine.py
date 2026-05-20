from src.reconciliation_engine import reconcile_payment


def test_reconciliation_success():
    result = reconcile_payment(
        intent_amount='10.00',
        intent_currency='USD',
        ledger_amount='10.00',
        ledger_currency='USD',
        payer_proof_verified=True,
        receiver_ack_verified=True,
    )
    assert result.passed is True
    assert result.errors == []


def test_reconciliation_amount_mismatch():
    result = reconcile_payment(
        intent_amount='10.00',
        intent_currency='USD',
        ledger_amount='9.99',
        ledger_currency='USD',
        payer_proof_verified=True,
        receiver_ack_verified=True,
    )
    assert result.passed is False
    assert 'Amount mismatch' in result.errors
