from src.domain.metro_card import MetroCard
from src.domain.journey import Journey
from src.domain.transaction import Transaction
from src.services.metro_system_service import MetroSystemService


def process_input(inputs):
    metro_cards = MetroCard()
    journeys = Journey()
    transactions = Transaction(metro_cards)
    metro_system_service = MetroSystemService(metro_cards, journeys, transactions)

    for input_params in inputs:
        if len(input_params) == 0:
            continue
        metro_system_service.process_input(input_params)
