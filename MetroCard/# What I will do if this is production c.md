# What I will do if this is production code? 

1. Add logging to the code to API (before and after requests) to track the requests and responses. 
2. Implement asyncio for asynchronously handling requests and to handle multiple requests concurrently. 
3. Implement rate limiting to prevent abuse and DDOS attacks. 
4. Add JWT auth to each file -> Implement a auth service that handles token checking, and Depends decorator to inject the token/current user into the request. 
5. Add a repository layer to handle the database operations.  
6. Caching if applicable, again keeping it centralised and abstracted away from the business logic.  
7. Integrate with APM ->Add tracing to the code to track the requests and responses. (we can use Datadog APM or OpenTelemetry) 
    -> Keep the provider abstracted away, even use a strategy pattern, in case of having multiple providers for different use cases.
