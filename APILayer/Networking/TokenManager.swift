//
//  TokenManager.swift
//  Network
//
//  Created by YOO on 2025/11/08.
//

import Foundation

actor TokenManager {
    static let shared = TokenManager()

    private init() {}

    private var accessToken: String?
    private var refreshToken: String?

    func updateTokens(access: String, refresh: String) {
        self.accessToken = access
        self.refreshToken = refresh
    }

    func getAccessToken() -> String? {
        accessToken
    }

    func refreshAccessToken() async throws -> String {
        guard let refreshToken else { throw APIError.unauthorized }

        var request = URLRequest(url: URL(string: "https://api.example.com/auth/refresh")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["refreshToken": refreshToken])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let status = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError.unknown(URLError(.badServerResponse))
        }

        guard (200..<300).contains(status) else {
            throw APIError.unauthorized
        }

        struct TokenResponse: Decodable {
            let accessToken: String
            let refreshToken: String?
        }

        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)

        self.accessToken = tokenResponse.accessToken
        if let newRefresh = tokenResponse.refreshToken {
            self.refreshToken = newRefresh
        }

        print("🔁 Token refreshed")

        return tokenResponse.accessToken
    }
}
