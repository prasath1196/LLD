import unittest
from unittest.mock import Mock
from src.services.fee_calculator_service import FeeCalculatorService
from src.domain.transaction import Transaction
from src.domain.metro_card import MetroCard


class TestFeeCalculatorService(unittest.TestCase):
    def setUp(self):
        """Set up test fixtures before each test method."""
        self.fee_calculator = FeeCalculatorService()
        self.metro_cards = MetroCard()
        self.transaction = Transaction(self.metro_cards)

    def test_calculate_fee_breakdown_first_journey(self):
        """Test fee calculation for first journey (no discount)."""
        # Arrange
        journey = {"mcid": "MC1", "passenger_type": "ADULT", "station_name": "CENTRAL"}
        self.metro_cards.add_card("MC1", 500.0)

        # Act
        result = self.fee_calculator.calculate_fee_breakdown(journey, self.transaction)

        # Assert
        self.assertEqual(result["mcid"], "MC1")
        self.assertEqual(result["passenger_type"], "ADULT")
        self.assertEqual(result["station_name"], "CENTRAL")
        self.assertEqual(result["fare"], 200)  # ADULT fare
        self.assertEqual(result["discount_amount"], 0)  # No discount for first journey
        self.assertEqual(result["discounted_fare"], 200)
        self.assertEqual(result["transaction_fee_amount"], 0)
        self.assertEqual(result["net_fare"], 200)

    def test_calculate_fee_breakdown_return_journey(self):
        """Test fee calculation for return journey (with discount)."""
        # Arrange
        journey = {"mcid": "MC1", "passenger_type": "ADULT", "station_name": "AIRPORT"}
        self.metro_cards.add_card("MC1", 500.0)
        self.transaction.mcid_counter = {"MC1": 1}  # Second journey

        # Act
        result = self.fee_calculator.calculate_fee_breakdown(journey, self.transaction)

        # Assert
        self.assertEqual(result["fare"], 200)  # ADULT fare
        self.assertEqual(result["discount_amount"], 100)  # 50% discount
        self.assertEqual(result["discounted_fare"], 100)
        self.assertEqual(result["transaction_fee_amount"], 0)
        self.assertEqual(result["net_fare"], 100)
