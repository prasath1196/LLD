# MetroCard Fare System (Python/FastAPI Sample)

## 🎯 Problem Statement

The goal was to build a fare calculation engine for a non-stop metro line between `CENTRAL` and `AIRPORT`. The system manages **MetroCard wallets**, processes **journeys**, and handles **automatic recharges** based on specific business rules.

**Core Business Rules:**
* **Fare Logic:** Fares differ by passenger type (`ADULT`: 200, `SENIOR`: 100, `KID`: 50).
* **Return Journey Discount:** Every 2nd trip for the same card is a "Return Journey" and receives a **50% discount**.
* **Auto-Recharge:** If a card has insufficient balance at check-in, it auto-recharges the *exact* required amount plus a **2% transaction fee**.
* **Reporting:** The system must output a station-wise summary of total collections and passenger counts.

---

## 🏗 Architectural Approach

I designed the system using **Clean Architecture** principles to ensure the core business logic is robust, testable, and completely decoupled from the HTTP delivery layer.

### 1. Layered Design
* **Domain Layer (`src/domain`):** Pure Python entities (`MetroCard`, `Journey`, `Transaction`) that encapsulate state and enforce data integrity.
* **Service Layer (`src/services`):** Contains the "Business Rules."
    * **`FeeCalculatorService`:** A dedicated service for complex pricing logic (discounts, surcharges). It is stateless and easily unit-tested.
    * **`MetroSystemService`:** Acts as a **Facade**, orchestrating interactions between the Domain entities and the Calculator.
* **Interface Layer (`src/api`):** The "Delivery Mechanism." It validates inputs using **Pydantic** and delegates work to the Service layer.

### 2. Key Design Decisions

#### **Framework Independence (Hexagonal Architecture)**
The core services (`MetroSystemService`, `FeeCalculatorService`) have **zero dependencies** on FastAPI or HTTP libraries.
* *Why:* This ensures the business logic is portable. We can swap the API framework, run it via a background worker, or trigger it from a CLI without rewriting a single line of domain code.

#### **Facade Pattern**
`MetroSystemService` serves as the single entry point for all operations.
* *Why:* It hides the complexity of the subsystem (coordinating the generic `Transaction` ledger, `Journey` history, and `FeeCalculator`) from the API controller. The API simply calls `check_in()` and receives the result.

#### **Centralized Error Handling**
I implemented a Python context manager (`exception_handler`) to wrap service calls.
* *Why:* It provides a clean, uniform way to map Domain Exceptions (like `ValueError: Invalid Card`) to HTTP responses (404/400) without cluttering the controller logic with `try/except` blocks.

---

## 📂 Project Structure

```text
.
├── src/
│   ├── api/          # Interface Layer (FastAPI Routes)
│   ├── domain/       # Enterprise Business Rules (Pure Python)
│   ├── dto/          # Data Transfer Objects (Pydantic Models)
│   ├── services/     # Application Business Rules
│   └── utils/        # Cross-cutting concerns (Exception Handling)
├── tests/            # Pytest suite
└── requirements.txt
🧪 Testing Strategy
The project uses pytest to ensure reliability at multiple levels:

Unit Tests (Isolated):

I focused heavily on FeeCalculatorService. By mocking the MetroCard and Transaction dependencies, I verified edge cases (e.g., "Does the 50% discount trigger exactly on the return trip?") without needing the full system state.

Integration Tests (API Level):

These tests spin up the FastAPI TestClient to verify that valid payloads result in 200 OK and invalid ones trigger the correct Pydantic validation errors (422 Unprocessable Entity).

Run the full suite:

Bash

python -m pytest
🚀 How to Run
Prerequisites
Python 3.8+

pip install -r requirements.txt

Start the Server
Bash

python -m uvicorn src.main:app --port 8000 --reload
Key Endpoints
POST /api/v1/cards/{mcid}/balance: Load balance (Idempotent).

POST /api/v1/journey: Check-in passenger (Triggers auto-recharge & fee calculation).

GET /api/v1/summary: specific station reporting.

🔮 Production Considerations
To scale this from a sample to a production system, I would introduce:

Persistence Layer: Replace the in-memory dictionaries with PostgreSQL, using SQLAlchemy for ORM mapping.

Concurrency Control: Implement optimistic locking (or SELECT FOR UPDATE) on the Card entity to prevent race conditions during simultaneous check-ins.

Authentication: Add an OAuth2 dependency to the FastAPI router to secure the endpoints.