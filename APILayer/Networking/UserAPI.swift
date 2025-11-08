//
//  UserAPI.swift
//  Network
//
//  Created by YOO on 2025/11/08.
//

import Foundation

enum UserAPI {
    case getUser(id: Int)
    case updateName(id: Int, name: String)
}

extension UserAPI: APIRouter {
    var baseURL: String { "https://api.example.com" }

    var path: String {
        switch self {
        case .getUser(let id): return "/users/\(id)"
        case .updateName(let id, _): return "/users/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getUser: return .GET
        case .updateName: return .PUT
        }
    }

    var headers: [String : String]? { ["Accept": "application/json"] }

    var body: Encodable? {
        switch self {
        case .updateName(_, let name): return ["name": name]
        default: return nil
        }
    }
}

/*
Task {
    TokenManager.shared.updateTokens(
        access: "expired_access_token",
        refresh: "valid_refresh_token"
    )

    do {
        let user: User = try await NetworkService.shared.request(UserAPI.getUser(id: 10))
        print("User:", user)
    } catch {
        print("❌ Error:", error)
    }
}
*/
