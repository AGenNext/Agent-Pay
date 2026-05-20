"""Agent-Pay reconciliation engine.

The reconciliation engine validates that payment intent, ledger, proof,
acknowledgement, provider, dispute, and escrow state agree before a payment
can be marked reconciled.
"""

from dataclasses import dataclass, field
from typing import List, Optional


@dataclass
class ReconciliationInput:
    payment_intent_status: str
    payment_intent_amount: str
    payment_intent_currency: str
    ledger_settlement_status: str
    ledger_reconciliation_status: str
    ledger_amount: str
    ledger_currency: str
    payable_status: str
    receivable_status: str
    payer_proof_status: Optional[str]
    receiver_ack_status: Optional[str]
    provider_payment: bool = False
    provider_status: Optional[str] = None
    provider_amount: Optional[str] = None
    provider_currency: Optional[str] = None
    open_dispute: bool = False
    escrow_required: bool = False
    escrow_status: Optional[str] = None


@dataclass
class ReconciliationResult:
    passed: bool
    errors: List[str] = field(default_factory=list)


class ReconciliationEngine:
    """Validates Agent-Pay reconciliation readiness."""

    def validate(self, data: ReconciliationInput) -> ReconciliationResult:
        errors: List[str] = []

        if data.payment_intent_status != 'settled':
            errors.append('payment_intent.status must be settled')

        if data.ledger_settlement_status != 'settled':
            errors.append('payment_ledger.settlement_status must be settled')

        if data.ledger_reconciliation_status not in {'not_started', 'pending'}:
            errors.append('payment_ledger.reconciliation_status must be not_started or pending')

        if data.payment_intent_amount != data.ledger_amount:
            errors.append('payment_intent.amount must equal payment_ledger.amount')

        if data.payment_intent_currency != data.ledger_currency:
            errors.append('payment_intent.currency must equal payment_ledger.currency')

        if data.payable_status != 'payable_settled':
            errors.append('payable_status must be payable_settled')

        if data.receivable_status != 'receivable_settled':
            errors.append('receivable_status must be receivable_settled')

        if data.payer_proof_status != 'verified':
            errors.append('payer_proof.verification_status must be verified')

        if data.receiver_ack_status != 'verified':
            errors.append('receiver_acknowledgement.verification_status must be verified')

        if data.provider_payment:
            if data.provider_status != 'succeeded':
                errors.append('provider_transaction.provider_status must be succeeded')
            if data.provider_amount != data.payment_intent_amount:
                errors.append('provider_transaction.amount must equal payment_intent.amount')
            if data.provider_currency != data.payment_intent_currency:
                errors.append('provider_transaction.currency must equal payment_intent.currency')

        if data.open_dispute:
            errors.append('payment cannot reconcile with an open dispute')

        if data.escrow_required and data.escrow_status not in {'released', 'retained'}:
            errors.append('escrow must be released or retained before reconciliation')

        return ReconciliationResult(passed=not errors, errors=errors)
