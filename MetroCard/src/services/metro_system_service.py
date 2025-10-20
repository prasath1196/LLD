from src.services.fee_calculator_service import FeeCalculatorService


class MetroSystemService:
    def __init__(self, metro_card, journey, transaction):
        self.metro_card = metro_card
        self.journey = journey
        self.transaction = transaction
        self.fee_calculator_service = FeeCalculatorService()

    def process_input(self, input_params):
        if input_params[0] == "BALANCE":
            self.metro_card.add_card(input_params[1], float(input_params[2]))
        elif input_params[0] == "CHECK_IN":
            journey_data = self.journey.add(
                input_params[1], input_params[2], input_params[3]
            )
            breakdown = self.fee_calculator_service.calculate_fee_breakdown(
                journey_data, self.transaction
            )
            self.transaction.add_jouney_transaction(breakdown)
        elif input_params[0] == "PRINT_SUMMARY":
            self.transaction.summary()
