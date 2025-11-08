//
//  NetworkService.swift
//  Network
//
//  Created by YOO on 2025/11/08.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum NetworkError: Error {
    case httpStatus(code: Int)
    case decodeFailure
}

struct NetworkService {

    static let shared = NetworkService()
    private init() {}

    /// Generic request function
    func request<T: Decodable, Body: Encodable>(
        _ url: URL,
        method: HTTPMethod = .GET,
        body: Body? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpStatus(code: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodeFailure
        }
    }
}

// 1. GET
/*
struct User: Decodable {
    let id: Int
    let name: String
}

let url = URL(string: "https://api.example.com/users/1")!

Task {
    do {
        let user: User = try await NetworkService.shared.request(url)
        print(user)
    } catch {
        print("GET Error:", error)
    }
}
*/

// 2. POST
/*
 struct NewUser: Encodable {
     let name: String
 }

 let url = URL(string: "https://api.example.com/users")!

 Task {
     do {
         let createdUser: User = try await NetworkService.shared.request(
             url,
             method: .POST,
             body: NewUser(name: "John")
         )
         print(createdUser)
     } catch {
         print("POST Error:", error)
     }
 }
 */
 
// 3. PUT
/*
 let url = URL(string: "https://api.example.com/users/1")!

 Task {
     do {
         let updatedUser: User = try await NetworkService.shared.request(
             url,
             method: .PUT,
             body: NewUser(name: "Updated Name")
         )
         print(updatedUser)
     } catch {
         print("PUT Error:", error)
     }
 }
 */

// 4. DELETE
/*
struct EmptyResponse: Decodable {}

let url = URL(string: "https://api.example.com/users/1")!

Task {
    do {
        let _: EmptyResponse = try await NetworkService.shared.request(
            url,
            method: .DELETE
        )
        print("Deleted successfully")
    } catch {
        print("DELETE Error:", error)
    }
}
*/
