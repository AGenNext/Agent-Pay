"""Provider adapter interfaces for Agent-Pay."""

from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Any, Dict, Optional


@dataclass
class ProviderPaymentRequest:
    payment_intent_id: str
    amount: str
    currency: str
    payer_reference: str
    payee_reference: str
    idempotency_key: str
    metadata: Optional[Dict[str, Any]] = None


@dataclass
class ProviderPaymentResult:
    provider_name: str
    external_transaction_id: str
    status: str
    amount: str
    currency: str
    raw_reference: Optional[str] = None


class PaymentProviderAdapter(ABC):
    """Base interface for payment provider adapters."""

    provider_name: str

    @abstractmethod
    def create_payment(self, request: ProviderPaymentRequest) -> ProviderPaymentResult:
        """Create or initiate a provider-side payment."""

    @abstractmethod
    def verify_payment(self, external_transaction_id: str) -> ProviderPaymentResult:
        """Verify provider-side payment status."""

    @abstractmethod
    def normalize_webhook(self, payload: Dict[str, Any]) -> ProviderPaymentResult:
        """Normalize provider webhook payload into Agent-Pay format."""
