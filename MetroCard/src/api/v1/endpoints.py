from fastapi import APIRouter, Path
from src.domain.metro_card import MetroCard
from src.domain.journey import Journey
from src.domain.transaction import Transaction
from src.services.metro_system_service import MetroSystemService
from fastapi import Request
from src.dto.endpoints import AddBalanceRequest, CheckInRequest
from src.utils.exception_handler import exception_handler

router = APIRouter(prefix="/api/v1")
metro_card = MetroCard()
journey = Journey()
transaction = Transaction(metro_card)
metro_system_service = MetroSystemService(metro_card, journey, transaction)


@router.post("/cards/{mcid}/balance")
async def create_card(
    request: Request,
    mcid: str = Path(..., pattern=r"^MC\d+$"),
    payload: AddBalanceRequest = ...,
):
    with exception_handler(request):
        metro_system_service.add_card(mcid, payload.amount)
        return {"message": "Balance added successfully"}


@router.post("/journey")
async def check_in(request: Request, payload: CheckInRequest):
    with exception_handler(request):
        journey_data = metro_system_service.check_in(
            payload.mcid, payload.passenger_type, payload.station_name
        )
        return journey_data


@router.get("/summary")
async def print_summary(request: Request):
    with exception_handler(request):
        return metro_system_service.get_summary()
