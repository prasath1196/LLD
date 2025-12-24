# MetroCard Code Walkthrough

**Commit SHA:** [PASTE_YOUR_COMMIT_SHA_HERE]

## 📍 Video Timestamp Mapping

| Time | Topic / File | Description |
| :--- | :--- | :--- |
| **00:00** | **Context** | Problem statement: Non-stop metro line, 2 stations, fare management. |
| **00:00:36** | **Folder Structure** | Overview of the transition from CLI-only to CLI + API structure. |
| **00:01:27** | `src/api/v1/` | Walkthrough of the Singleton pattern used for in-memory state and the 3 main endpoints. |
| **00:02:01** | `src/utils/` | **Exception Handling:** Centralized context manager to map domain errors to HTTP responses. |
| **00:02:42** | `src/dto/` | **DTOs:** Pydantic models for `AddBalanceRequest` and `CheckInRequest` validation. |
| **00:03:21** | `src/services/` | **Service Layer:** `MetroSystemService` as the facade to keep controllers thin. |
| **00:04:13** | `src/domain/` | **Domain Layer:** Pure Python logic for `MetroCard` and `Journey` (no framework dependencies). |
| **00:04:47** | `FeeCalculator` | Deep dive into the `FeeCalculatorService` and `Transaction` logic. |
| **00:05:21** | **Logging** | Strategy pattern for logging (currently dict-style, extensible for Datadog/APM). |
| **00:06:10** | `tests/` | **Testing:** Validation tests for valid cards, invalid ticket IDs, and edge cases. |
| **00:06:50** | **Production Roadmap** | Future improvements: Async IO, Rate Limiting, JWT Auth, and Postgres DB migration. |

---

## 📝 Full Transcript

**00:00:03** Hey, Stephen. So hi, this is Prasad. So I'm going to go with the MetroCorp at a very high level to give you an give you enough point as to what have changed and what is this all about.

**00:00:13** So before diving into it, I'll just give a context of what is what this is actually doing. So the problem statement is a customer, basically a metro system, but that's just has two stations and a customer is driving from one station to one other station. And the system basically manages the transactions and balance check of the metro system.

**00:00:36** So here we have the folder structure. So previous to, I mean, before this task, previously I had the following code and ready, which is I had the services, this business logic was already there. And then in the metro system service, I had up until this part where I'm selecting here up to process input. It was a CLA application when I was doing this task previously, but right now I have added these methods in order to support the API.

**00:01:05** I've added the API folder here. I've added the DTO here to handle the request response. I've added utils here to centralize exception and logger. And I also had test here to test the API that I just wrote. So these are some changes that I did today. So let me dive into it.

**00:01:27** So first let's see the APIs that I've added. So I versioned the API as V1 and then if you go into this, is our API folder. So I follow a singleton pattern here to you by initializing all these objects and services. Since there is no database, I've gone with the singleton pattern. And basically there are three APIs. One is to add the balance to the card. One is to check in a customer for a journey. Another is to see the entire summary of all the transaction maybe on the customers.

**00:02:01** So this is what it is pretty much about. And then I have wrapped, I've used a centralized context manager here. I've also used some DTOs here, which I'll just show you. So in the exception handler, I've just used the context manager to implement it so that I can wrap whatever the API right in the future with this and then also center this for the exception so that each and every API endpoints delivers a consistent and clear exception. And if there is any change that is needed to the error message, this is the only file we need to touch. We can even go further and encapsulate the error messages into a separate constants file and then just edit that and use those constants across the application for more extensibility.

**00:02:42** So this is what the exception handle is about. Let me jump to the TTO. So here we have two models. Basically, it's a pretty simple one for the use case. We have ad balance request and check-in request used to validate the request and response here. And that's pretty much it. You can see that I validated the pattern of the ticket ID. I've had an enum for checking whether The passenger type is within allowed limits and station name. Of course, when it goes to a production system, we have databases and those types can be stored in databases for more extensibility.

**00:03:21** Let me now jump into the service part of where I have these three methods. So I did not want the APIs to directly call the models. I want to exactly keep all the business logic strictly to metro system service and service is going to call the domain or models. so that the controllers or the API parts is not bloated. I want to keep them thin so that whoever reads the code can understand how the system works in a glance.

**00:03:52** I added these three methods, which basically calls some model or domain methods that is going to push the data into our domain objects. So AdCode is going to push data into the MetroCode object, and JourneyData is going to push the data into the journey and transaction.

**00:04:13** So these are our domains. We have a journey domain. Basically, whenever a customer makes a journey, we push data into this. We have MetroCard domain. It has four methods, add card, recharge, get balance, and direct balance. This gets called from various places, sometimes from the calculate fee service, whenever a customer is making a check-in or checking for a journey.

**00:04:47** The fee calculator service gets called by the metro system service, which is going to call all these methods here to ensure the customer's transaction details are saved properly. And there's also transaction fee where that is going to save all the transactions that has been happening in the entire metro system into an array here. And then also it has some business logic that handles the fair calculation, transaction amount calculation, and discount amount calculation.

**00:05:21** Let me now jump into the logging part. So I've had a centralized logger. So right now it's just a simple logger that uses very basic dictionary style logging of information. But the idea is, say for example, we have a metro system service and then right now we're just doing this info log. And tomorrow we want to push our logs to maybe Datadog or any other APM. All we have to do is to make changes here, get a different logger, and then maybe add another method if you want also here, and then use that logger to push those messages rather than changing anywhere. So that gives us a very easy way to extend this code or change this code without touching all cases in the code.

**00:06:10** So let me move to test cases. So everything is wrapping APIV1. If you go to influence.test, I've tried and added as much as I can today. So I added a create a valid card test with an invalid amount with an invalid ticket ID. Similarly for check-in with invalid ticket ID, passenger type, station name, so on and so forth. So try to do it pretty much extensively.

**00:06:50** Finally, I'll move on to explain what I'll be doing to improve the code. If it has to move to production, the first thing is to improve the logging. Right now, it's a very basic logging right now, and it doesn't track the API request response. So I'll add it to track the API request and response, add unique request IDs to push. Second is implementing asynchronous way to handle the request maybe we're using an async IO library.

**00:07:35** For example, if you see in this endpoints.py, this request can be concurrent and then we don't have any asynchronous, even though this action suppose asynchronous calls, we have actually not gone ahead and implemented any asynchronous or concurrent actions here. We can implement that so that thousands of requests can go through, and our system can support that level of consistency. While we do that, we should also be aware of rate limiting. We don't want our systems to be, you know, flooded with requests, so we can add rate limiting to our system.

**00:08:13** So, and an obvious thing is obviously to add a JWT auth. So to implement, I would use an auth service here inside the service, which actually, and then write a middleware actually to capture all the requests and then see, and then that comes uses the auth service to determine whether this action needs authentication or not.

**00:09:05** And to add a repository layer and to add a database, that's also obvious. But database operations, I would not keep everything in the domain. I'll move the database injections to repository layer. This is because, again, to decouple domain, which is a pure Python thing from databases, which can be today, post press, tomorrow, maybe Aurora and Amazon error or MySQL or even Mongo. So, keeping all those retail abstracted away from the core domain and business logic is critical, so I'll move to the repository layer.