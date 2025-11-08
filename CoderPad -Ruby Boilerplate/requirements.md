Functional Requirements
Entry Flow
Vehicle arrives at gate
Assign slot based on vehicle type
Generate ticket
Mark slot as occupied
Return entry response
Exit Flow
Present ticket
Calculate fee using pricing rules (flat vs hourly)
Process payment
Release slot
Return exit response with receipt
Admin Flow
Add/Edit/Delete floors and slots
Define/update pricing rules
View parking lot status

Interview Tip: Always ask the interviewer to confirm the requirements before jumping into code. It shows clarity and alignment.

Non-Functional Requirements
Scalability: Multiple parking lots, thousands of slots
Availability: Entry/Exit must work even if payment fails
Consistency: Accurate slot status at all times
Extensibility: Easy addition of new vehicle types or gateways
Security: Role-based access for admin operations
Latency: < 500ms for key flows

Edge Cases to Consider
Payment failure at exit
Lost ticket
System clock mismatch
Slot marked occupied wrongly
