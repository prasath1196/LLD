from fastapi.testclient import TestClient
import importlib
import pytest
from src.main import app
from src.api.v1 import endpoints as endpoints_module


@pytest.fixture
def client():
    return TestClient(app)


@pytest.fixture(autouse=True)
def _reset_api_state():
    importlib.reload(endpoints_module)


def test_create_card_valid(client):
    response = client.post("/api/v1/cards/MC1/balance", json={"amount": 100})
    assert response.status_code == 200
    assert response.json() == {"message": "Balance added successfully"}


def test_create_card_invalid_amount(client):
    response = client.post("/api/v1/cards/MC1/balance", json={"amount": -100})
    assert response.status_code == 422


def test_create_card_invalid_mcid(client):
    response = client.post("/api/v1/cards/abcd/balance", json={"amount": 100})
    assert response.status_code == 422


def test_check_in(client):
    client.post("/api/v1/cards/MC1/balance", json={"amount": 100})
    response = client.post(
        "/api/v1/journey",
        json={"mcid": "MC1", "passenger_type": "ADULT", "station_name": "CENTRAL"},
    )
    assert response.status_code == 200
    assert response.json() == {
        "mcid": "MC1",
        "passenger_type": "ADULT",
        "fare": 200,
        "discount_amount": 0,
        "discounted_fare": 200,
        "station_name": "CENTRAL",
        "transaction_fee_amount": 2.0,
        "net_fare": 202.0,
    }


def test_check_in_invalid_mcid(client):
    response = client.post(
        "/api/v1/journey",
        json={"mcid": "abcd", "passenger_type": "ADULT", "station_name": "CENTRAL"},
    )
    assert response.status_code == 422


def test_check_in_invalid_passenger_type(client):
    response = client.post(
        "/api/v1/journey",
        json={"mcid": "MC1", "passenger_type": "INVALID", "station_name": "CENTRAL"},
    )
    assert response.status_code == 422


def test_check_in_invalid_station_name(client):
    response = client.post(
        "/api/v1/journey",
        json={"mcid": "MC1", "passenger_type": "ADULT", "station_name": "INVALID"},
    )
    assert response.status_code == 422


def test_check_in_mcid_not_found(client):
    response = client.post(
        "/api/v1/journey",
        json={"mcid": "MC1", "passenger_type": "ADULT", "station_name": "CENTRAL"},
    )
    assert response.status_code == 404


def test_print_summary(client):
    client.post("/api/v1/cards/MC1/balance", json={"amount": 100})
    client.post(
        "/api/v1/journey",
        json={"mcid": "MC1", "passenger_type": "ADULT", "station_name": "CENTRAL"},
    )
    response = client.get("/api/v1/summary")
    assert response.status_code == 200
    assert response.json() == {
        "CENTRAL": {
            "total_collection": 202.0,
            "total_discount": 0,
            "passenger_count": {"ADULT": 1},
        }
    }
