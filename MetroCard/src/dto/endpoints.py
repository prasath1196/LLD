from typing import Literal

from pydantic import BaseModel, Field


class AddBalanceRequest(BaseModel):
    amount: float = Field(..., ge=0)


class CheckInRequest(BaseModel):
    mcid: str = Field(..., min_length=1, max_length=10, pattern=r"^MC\d+$")
    passenger_type: Literal["ADULT", "SENIOR_CITIZEN", "KID"]
    station_name: Literal["CENTRAL", "AIRPORT"]
