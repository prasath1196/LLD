## MetroCard (LLD) — CLI + FastAPI

This repo contains **two ways to run the same MetroCard domain logic**:
- **CLI mode**: reads commands from a text file and prints the summary to stdout.
- **API mode (FastAPI)**: exposes minimal endpoints for adding balance, checking in, and retrieving a JSON summary.

---

## Problem statement (concise)

Build a **MetroCard-based fare system** for a **non-stop metro line** between `CENTRAL` and `AIRPORT` (both directions). Each trip is paid using a **MetroCard wallet** identified by a unique card number.

### Fare rules
- Base fare depends on passenger type: `ADULT` / `SENIOR_CITIZEN` / `KID`.
- Trips are counted per card; **every 2nd trip** for the same card is a **return journey** and gets **50% discount** on the base fare.
- If the card has insufficient balance, **auto-recharge exactly the required amount** and charge an additional **2% service fee** on the recharge amount (fee collected at the journey’s origin station).

### Goal / Output
Process a list of commands (balance loads + check-ins), then print **station-wise summary**:
- Total collection amount
- Total discount given
- Passenger count by type, sorted by count descending; ties by passenger type ascending.

Passenger count is based on **journeys**, not unique people/cards.

---

## Pre-requisites
- **Python**: 3.8 / 3.9
- **pip**

---

## Quickstart (CLI)

### Install
```bash
python3 -m pip install -r requirements.txt
```

### Run with sample input
```bash
python3 -m cli sample_input/input1.txt
```

### Using scripts
- macOS/Linux:
```bash
./run.sh
```
- Windows:
```bat
run.bat
```

To run another input file, update the script command to:
```bash
python3 -m cli sample_input/input2.txt
```

---

## Quickstart (API)

### Run server
```bash
python3 -m uvicorn src.main:app --port 8000
```

### Endpoints
- **Add / set card balance**
  - `POST /api/v1/cards/{mcid}/balance`
  - `mcid` must match: `^MC\d+$` (example: `MC1`)
  - body: `{"amount": 100}`

- **Check-in (creates a journey + charges fare)**
  - `POST /api/v1/journey`
  - body: `{"mcid": "MC1", "passenger_type": "ADULT", "station_name": "CENTRAL"}`

- **Summary**
  - `GET /api/v1/summary`
  - returns aggregated summary JSON by station

### Example curl
```bash
curl -X POST "http://127.0.0.1:8000/api/v1/cards/MC1/balance" \
  -H "Content-Type: application/json" \
  -d '{"amount": 100}'
```

```bash
curl -X POST "http://127.0.0.1:8000/api/v1/journey" \
  -H "Content-Type: application/json" \
  -d '{"mcid":"MC1","passenger_type":"ADULT","station_name":"CENTRAL"}'
```

```bash
curl "http://127.0.0.1:8000/api/v1/summary"
```

---

## Running tests

This repo uses **pytest**.

```bash
python3 -m pytest -q
```

Run a single file:
```bash
python3 -m pytest tests/api/v1/endpoints_test.py -q
```

---

## Code organization

### `src/domain/` (Domain Models)
- **`MetroCard`**: in-memory card store + balance operations (`add_card`, `recharge`, `deduct_balance`)
- **`Journey`**: stores journey records
- **`Transaction`**: stores charged line-items, provides:
  - `summary()` for **CLI** (prints formatted output)
  - `summary_data()` for **API** (returns JSON-friendly dict)

### `src/services/` (Business Logic)
- **`MetroSystemService`**: orchestrates commands/endpoints: add card, check-in, summary
- **`FeeCalculatorService`**:
  - fare by passenger type (`constants.py`)
  - return-journey discount (every 2nd trip per card)
  - auto-recharge + transaction fee when balance is insufficient

### `src/dto/` (Request DTOs)
- **`AddBalanceRequest`** / **`CheckInRequest`**:
  - schema validation (e.g., `mcid` must be `MC` + digits)
  - enums for passenger and station

### `src/api/v1/` (API layer)
- **`endpoints.py`**: FastAPI routes. Note that the API currently uses **in-memory singletons** initialized at module import time.

### `src/utils/`
- **`exception_handler.py`**: shared context-manager style error mapping for endpoints.

---

## Behavior notes (important)
- **In-memory state**: API state lives in-process (no DB). Restarting the server resets all cards/journeys.
- **Test isolation**: tests reload the endpoints module to reset in-memory state between test cases.
- **Error handling**:
  - input/schema violations => FastAPI returns 422 (request validation)
  - domain “not found” (`Invalid Card`) => mapped to 404 via `exception_handler`

---

## Design trade-offs (Q&A) — please fill in

These are the questions I (Prasath) would answer in a real production design review.
If you’re reviewing this repo, I can respond inline (or on a call) with the rationale.

1. **State & persistence**
   - Why choose **in-memory** storage vs a DB/repository abstraction?
   - What’s the intended lifecycle for this service (single process vs scaled horizontally)?
   - If we added Postgres, what would the repository boundaries be?

2. **API vs CLI parity**
   - What should be the source of truth for output formatting: JSON model vs text formatting?
   - Should `/summary` return the same structure as the CLI summary or a richer one?

3. **Validation**
   - Why validate `mcid` both as a **path param** and inside DTOs?
   - Should passenger/station values be strict enums, or allow extension via config?

4. **Error handling**
   - Should we use per-endpoint context managers (`exception_handler`) or FastAPI global exception handlers?
   - Which errors should be **400 vs 404 vs 422 vs 500**?
   - Should responses include stable error codes (e.g., `{"code": "...", "message": "..."}`) for clients?

5. **Test strategy**
   - Why use module reload for state reset vs explicit dependency injection?
   - What additional cases are “must have” for production (idempotency, concurrency, etc.)?

---

## References
- (Removed GeekTrust-specific runner wording; CLI entrypoint is `cli.py`.)