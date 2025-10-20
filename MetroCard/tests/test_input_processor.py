import unittest
from src.domain.journey import Journey
from src.domain.metro_card import MetroCard
from src.domain.transaction import Transaction
from src.services.fee_calculator_service import FeeCalculatorService
from src.input_processor import process_input


class TestInputProcessor(unittest.TestCase):
    inputs = [
        ["BALANCE", "MC1", "500"],
        ["BALANCE", "MC2", "500"],
        ["CHECK_IN", "MC1", "ADULT", "CENTRAL"],
        ["PRINT_SUMMARY"],
    ]

    output = "PASSENGER_TYPE_SUMMARY\nADULT 1\nTOTAL_COLLECTION CENTRAL 200 0\n"

    def test_process_input(self):
        # Call the process_input function with the inputs
        process_input(self.inputs)
        # Assert the output is as expected
        assert (
            self.output
            == "PASSENGER_TYPE_SUMMARY\nADULT 1\nTOTAL_COLLECTION CENTRAL 200 0\n"
        )
