from src.services.fee_calculator_service import FeeCalculatorService
from src.utils.logger import get_logger

log = get_logger(__name__)


class MetroSystemService:
    def __init__(self, metro_card, journey, transaction):
        self.metro_card = metro_card
        self.journey = journey
        self.transaction = transaction
        self.fee_calculator_service = FeeCalculatorService()

    def process_input(self, input_params):
        if input_params[0] == "BALANCE":
            self.add_card(input_params[1], float(input_params[2]))
        elif input_params[0] == "CHECK_IN":
            journey_data = self.check_in(
                input_params[1], input_params[2], input_params[3]
            )
            return journey_data
        elif input_params[0] == "PRINT_SUMMARY":
            return self.print_summary()

    def add_card(self, mcid, amount):
        self.metro_card.add_card(mcid, amount)
        log.info(f"Card {mcid} added with amount {amount}")

    def check_in(self, mcid, passenger_type, station_name):
        journey_data = self.journey.add(mcid, passenger_type, station_name)
        log.info(f"Journey added for card {mcid} at station {station_name}")
        breakdown = self.fee_calculator_service.calculate_fee_breakdown(
            journey_data, self.transaction
        )
        log.info(f"Fee breakdown Calculated: {breakdown}")
        self.transaction.add_jouney_transaction(breakdown)
        return breakdown

    def print_summary(self):
        return self.transaction.summary()

    def get_summary(self):
        summary_data = self.transaction.summary_data()
        log.info(f"Summary data: {summary_data}")
        return summary_data
