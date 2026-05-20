from .base import PaymentProviderAdapter, ProviderPaymentRequest, ProviderPaymentResult


class StripeAdapter(PaymentProviderAdapter):
    provider_name = 'stripe'

    def create_payment(self, request: ProviderPaymentRequest) -> ProviderPaymentResult:
        raise NotImplementedError

    def verify_payment(self, external_transaction_id: str) -> ProviderPaymentResult:
        raise NotImplementedError

    def normalize_webhook(self, payload):
        raise NotImplementedError
