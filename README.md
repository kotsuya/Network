
## Network

### feature
 - Swift Concurrency (async/await) based
 - Uses URLSession
 - JSON encoding/decoding
 - Common HTTP method handling
 - Includes request/response loggin(can be removed if needed)

 ## APILayer

Alamofire-style network layer, including automatic refresh (retries) of access tokens and refresh tokens.

### folder 
```
Networking/
 ├── NetworkService.swift
 ├── APIError.swift
 ├── APIRouter.swift
 ├── TokenManager.swift
 └── UserAPI.swift
Example/
 ├── PostView.swift
 ├── PostViewModel.swift
 └── PostAPI.swift
```
### feature 
✅ Based on Swift 6 async/await.
✅ When a token expires, it automatically refreshes and re-requests.
✅ Even with concurrent requests, only one refresh is performed, and the remaining requests are queued, refreshed, and retried.
