Here is the `requirements.md` file based on our conversation.

---

# `requirements.md`

## V1: Core Vending Machine Functionality

Design an in-memory, object-oriented vending machine that can successfully handle a single transaction.

---

## Agreed-Upon Object Models

1.  **`Product`**

    - **Attributes:**
      - `@name` (e.g., "Cola")
      - `@price` (e.g., 150) - stored in cents as an integer

2.  **`Slot`**

    - **Attributes:**
      - `@id` (e.g., "A1")
      - `@product` (an instance of the `Product` class)
      - `@quantity` (an integer, e.g., 10)
    - **Behaviors:**
      - `is_empty?`
      - `dispense_one`

3.  **`VendingMachine`**
    - **Attributes:**
      - `@slots` (an array of `Slot` objects)
      - `@current_balance` (an integer, e.g., 0)
    - **Behaviors:**
      - `insert_coin(coin_value)`
      - `select_product(slot_id)`
      - `cancel_request`

---

## Functional Requirements

### 1. Money Handling

- The machine must accept money from a user.
  - `insert_coin(coin_value)`: This method should increase the machine's `@current_balance`.
- All money is handled as **integers representing cents** (e.g., Quarter = 25, Dime = 10, Nickel = 5).

### 2. Product Selection & Purchase

- The user selects a product by its `@id` (e.g., "A1").
- The machine must check if the `@current_balance` is sufficient to cover the product's price.
- **If successful (sufficient funds):**
  - The machine must "dispense" the product (e.g., decrement the slot's quantity by 1).
  - The machine must calculate and return the correct change.
  - The `@current_balance` must be reset to 0.
- **If unsuccessful (insufficient funds):**
  - The machine must return an error message (e.g., "Insufficient funds").
  - It must _not_ dispense the product or reset the balance.

### 3. Cancel Request

- The user must be able to cancel their transaction at any time _before_ a purchase is confirmed.
- `cancel_request`: This method should return the entire `@current_balance` to the user and reset it to 0.

### 4. Display

- The machine must be able to display all available items, their prices, and their slot IDs.

---

## V1 - Assumptions & Scoped-Out Features

- **No Transaction History:** The machine does not need to log or persist a history of past transactions.
- **Atomic Transactions:** A purchase, once selected, is instant. We will not handle a "cancel" _during_ the dispensing process.
- **No Change-Making Issues:** For V1, we assume the machine has an infinite supply of coins to make change.
- **Single User:** We only need to handle one user/transaction at a time.
