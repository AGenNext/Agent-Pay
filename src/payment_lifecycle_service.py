"""Agent-Pay lifecycle service scaffold.

This module provides a reference implementation for enforcing lifecycle
transitions defined in rules/payment_lifecycle.md.
"""

from dataclasses import dataclass
from typing import Optional


class PaymentLifecycleError(Exception):
    pass


@dataclass
class PaymentIntent:
    id: str
    status: str
    amount: str
    currency: str
    payment_mode: str


class PaymentLifecycleService:
    """Reference lifecycle orchestration service."""

    def authorize_payment(self, intent: PaymentIntent, approved_by: str) -> PaymentIntent:
        if intent.status != 'requested':
            raise PaymentLifecycleError('Payment must be in requested state')
        if not approved_by:
            raise PaymentLifecycleError('approved_by is required')
        intent.status = 'authorized'
        return intent

    def submit_payer_proof(self, intent: PaymentIntent, proof_verified: bool) -> PaymentIntent:
        if intent.status != 'authorized':
            raise PaymentLifecycleError('Payment must be authorized')
        if not proof_verified:
            raise PaymentLifecycleError('Payer proof must be verified')
        intent.status = 'payer_proof_submitted'
        return intent

    def acknowledge_receipt(self, intent: PaymentIntent, acknowledgement_verified: bool) -> PaymentIntent:
        if intent.status != 'payer_proof_submitted':
            raise PaymentLifecycleError('Payer proof must be submitted')
        if not acknowledgement_verified:
            raise PaymentLifecycleError('Receiver acknowledgement must be verified')
        intent.status = 'receiver_acknowledged'
        return intent

    def settle_payment(self, intent: PaymentIntent) -> PaymentIntent:
        if intent.status != 'receiver_acknowledged':
            raise PaymentLifecycleError('Receiver acknowledgement required')
        intent.status = 'settled'
        return intent

    def reconcile_payment(self, intent: PaymentIntent, checks_passed: bool) -> PaymentIntent:
        if intent.status != 'settled':
            raise PaymentLifecycleError('Payment must be settled')
        if not checks_passed:
            raise PaymentLifecycleError('Reconciliation checks failed')
        intent.status = 'reconciled'
        return intent
