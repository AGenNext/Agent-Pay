"""Agent-Pay reconciliation engine."""

from dataclasses import dataclass
from decimal import Decimal
from typing import List


@dataclass
class ReconciliationResult:
    passed: bool
    errors: List[str]


def reconcile_payment(intent_amount: str, intent_currency: str,
                      ledger_amount: str, ledger_currency: str,
                      payer_proof_verified: bool,
                      receiver_ack_verified: bool,
                      dispute_open: bool = False) -> ReconciliationResult:
    errors: List[str] = []

    if Decimal(intent_amount) != Decimal(ledger_amount):
        errors.append('Amount mismatch')

    if intent_currency != ledger_currency:
        errors.append('Currency mismatch')

    if not payer_proof_verified:
        errors.append('Payer proof not verified')

    if not receiver_ack_verified:
        errors.append('Receiver acknowledgement not verified')

    if dispute_open:
        errors.append('Open dispute exists')

    return ReconciliationResult(passed=len(errors) == 0, errors=errors)
