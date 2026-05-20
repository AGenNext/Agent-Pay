from src.payment_lifecycle_service import PaymentIntent, PaymentLifecycleService


def test_happy_path():
    service = PaymentLifecycleService()
    intent = PaymentIntent(
        id='pi_001',
        status='requested',
        amount='10.00',
        currency='USD',
        payment_mode='provider_payment',
    )

    service.authorize_payment(intent, approved_by='platform')
    service.submit_payer_proof(intent, proof_verified=True)
    service.acknowledge_receipt(intent, acknowledgement_verified=True)
    service.settle_payment(intent)
    service.reconcile_payment(intent, checks_passed=True)

    assert intent.status == 'reconciled'
