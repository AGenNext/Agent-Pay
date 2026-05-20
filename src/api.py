from fastapi import FastAPI
from pydantic import BaseModel

from .payment_lifecycle_service import PaymentIntent, PaymentLifecycleService

app = FastAPI(title='Agent-Pay API')
service = PaymentLifecycleService()

# Simple in-memory store for scaffold purposes.
PAYMENTS = {}


class CreatePaymentIntentRequest(BaseModel):
    id: str
    amount: str
    currency: str
    payment_mode: str = 'provider_payment'


@app.get('/health')
def health():
    return {'status': 'ok'}


@app.post('/payment-intents')
def create_payment_intent(request: CreatePaymentIntentRequest):
    intent = PaymentIntent(
        id=request.id,
        status='requested',
        amount=request.amount,
        currency=request.currency,
        payment_mode=request.payment_mode,
    )
    PAYMENTS[intent.id] = intent
    return intent.__dict__


@app.post('/payment-intents/{payment_id}/authorize')
def authorize_payment(payment_id: str):
    intent = service.authorize_payment(PAYMENTS[payment_id], approved_by='platform')
    return intent.__dict__


@app.post('/payment-intents/{payment_id}/submit-proof')
def submit_payer_proof(payment_id: str):
    intent = service.submit_payer_proof(PAYMENTS[payment_id], proof_verified=True)
    return intent.__dict__


@app.post('/payment-intents/{payment_id}/acknowledge')
def acknowledge_receipt(payment_id: str):
    intent = service.acknowledge_receipt(PAYMENTS[payment_id], acknowledgement_verified=True)
    return intent.__dict__


@app.post('/payment-intents/{payment_id}/settle')
def settle_payment(payment_id: str):
    intent = service.settle_payment(PAYMENTS[payment_id])
    return intent.__dict__


@app.post('/payment-intents/{payment_id}/reconcile')
def reconcile_payment(payment_id: str):
    intent = service.reconcile_payment(PAYMENTS[payment_id], checks_passed=True)
    return intent.__dict__
