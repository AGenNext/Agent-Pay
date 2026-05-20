"""Repository contract for Agent-Pay payment persistence.

This module defines the storage boundary used by services and APIs.
Concrete implementations should persist to SurrealDB tables defined in
schema/payment_core.surql and schema/payment_extensions.surql.
"""

from abc import ABC, abstractmethod
from typing import Any, Dict, Optional


class PaymentRepositoryContract(ABC):
    """Abstract repository boundary for Agent-Pay persistence."""

    @abstractmethod
    async def create_payment_intent(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Create a payment_intent record."""

    @abstractmethod
    async def get_payment_intent(self, payment_id: str) -> Optional[Dict[str, Any]]:
        """Fetch a payment_intent by record id."""

    @abstractmethod
    async def update_payment_status(
        self,
        payment_id: str,
        new_status: str,
        changed_by: str,
        changed_by_role: str,
        reason: Optional[str] = None,
        evidence_ref: Optional[str] = None,
    ) -> Dict[str, Any]:
        """Update payment status and create payment_status_audit atomically."""

    @abstractmethod
    async def create_payer_proof(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Create a payer_proof record."""

    @abstractmethod
    async def create_receiver_acknowledgement(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Create a receiver_acknowledgement record."""

    @abstractmethod
    async def create_payment_ledger(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Create a payment_ledger record."""
