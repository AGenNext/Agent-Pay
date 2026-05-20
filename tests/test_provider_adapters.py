from src.providers.stripe_adapter import StripeAdapter
from src.providers.paypal_adapter import PayPalAdapter
from src.providers.upi_adapter import UPIAdapter


def test_provider_names():
    assert StripeAdapter().provider_name == 'stripe'
    assert PayPalAdapter().provider_name == 'paypal'
    assert UPIAdapter().provider_name == 'upi'
