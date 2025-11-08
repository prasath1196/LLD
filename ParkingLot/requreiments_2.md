Goals: Design a parking lot using object-oriented principles

Here are a few methods that you should be able to run:

Tell us how many spots are remaining
Tell us how many total spots are in the parking lot
Tell us when the parking lot is full
Tell us when the parking lot is empty
Tell us when certain spots are full e.g. when all motorcycle spots are taken
Tell us how many spots vans are taking up
Assumptions:

The parking lot can hold motorcycles, cars and vans
The parking lot has motorcycle spots, car spots and large spots
A motorcycle can park in any spot
A car can park in a regular or large spot
A van can park in a large spot, but it will take up 3 regular spots
These are just a few assumptions. Feel free to ask your interviewer about more assumptions as needed

Questions:
1. Is car spots and regular spot the same? 
2. How many motor cycles can be parked in regular/car spots ?
3. Is van spot thrice the size of car/regular spot? -> 3 cars in one large spot


## Revised Assumptions
### Parking Spots:  
The parking lot consists of regular spots only.
Vehicle Types:

Motorcycles can park in any regular spot.
Cars can park in any regular spot.
Vans can park in three consecutive regular spots, accounting for their space requirements.
Spot Occupancy:

Each spot can hold only one motorcycle or one car.
A van occupies three regular spots as a single unit.
Capacity:

The total number of spots is fixed.
The parking lot can be full or empty based on the occupancy levels.
Spot Counting:

Spot count includes all occupied spots (motorcycles, cars, and vans’ equivalent spots).

----------------------------------
Entities:
1. Vehicle
2. ParkingSlot 
3. ParkingLot



