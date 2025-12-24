from constants import (
    TRANSACTION_FEE_PERCENTAGE,
    DISCOUNT_PERCENTAGE,
    TICKET_FARE,
)  # Constants are used to avoid magic numbers and strings
from src.utils.logger import get_logger

log = get_logger(__name__)


class FeeCalculatorService:
    def __init__(self):
        self.TRANSACTION_FEE = TRANSACTION_FEE_PERCENTAGE
        self.DISCOUNT = DISCOUNT_PERCENTAGE
        self.ticket_fare = TICKET_FARE

    def calculate_fee_breakdown(self, journey, transaction):
        mcid = journey["mcid"]
        passenger_type = journey["passenger_type"]
        station_name = journey["station_name"]

        if mcid in transaction.mcid_counter:
            transaction.mcid_counter[mcid] += 1
        else:
            transaction.mcid_counter[mcid] = 1

        # Calculate base fare
        base_fare = self.ticket_fare[passenger_type]

        # Calculate discount (50% for return journeys)
        discount = 0
        if transaction.mcid_counter[mcid] % 2 == 0:
            discount = base_fare * self.DISCOUNT

        # Calculate discounted charge
        discounted_charge = base_fare - discount

        # Check if recharge is needed
        available_balance = transaction.metro_cards.get_balance(mcid)
        transaction_fee = 0

        if available_balance < discounted_charge:
            required_recharge = discounted_charge - available_balance
            transaction_fee = round(self.TRANSACTION_FEE * required_recharge, 2)
            total_recharge = required_recharge + transaction_fee
            transaction.metro_cards.recharge(mcid, total_recharge)

        # Deduct the travel cost
        transaction.metro_cards.deduct_balance(mcid, discounted_charge)

        # Calculate net charge
        net_charge = discounted_charge + transaction_fee

        line_item = {
            "mcid": mcid,
            "passenger_type": passenger_type,
            "fare": base_fare,
            "discount_amount": discount,
            "discounted_fare": discounted_charge,
            "station_name": station_name,
            "transaction_fee_amount": transaction_fee,
            "net_fare": net_charge,
        }
        log.info(f"Fee breakdown Calculated: {line_item}")
        return line_item
