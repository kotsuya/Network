//
//  NetworkService.swift
//  Network
//
//  Created by YOO on 2025/11/08.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}

    private var isRefreshing = false
    private var pendingRequests: [(String) async throws -> Void] = []

    func request<T: Decodable>(_ router: APIRouter) async throws -> T {
        let token = await TokenManager.shared.getAccessToken()
        let request = try router.asURLRequest(withAccessToken: token)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown(URLError(.badServerResponse))
            }

            switch httpResponse.statusCode {
            case 200..<300:
                return try JSONDecoder().decode(T.self, from: data)

            case 401:
                return try await handleUnauthorized(router: router)

            default:
                throw APIError.httpStatus(code: httpResponse.statusCode)
            }

        } catch {
            throw APIError.unknown(error)
        }
    }

    private func handleUnauthorized<T: Decodable>(router: APIRouter) async throws -> T {
        print("⚠️ 401 Unauthorized — trying refresh token")

        return try await withCheckedThrowingContinuation { continuation in
            pendingRequests.append { newToken in
                Task {
                    do {
                        let retryRequest = try router.asURLRequest(withAccessToken: newToken)
                        let (retryData, _) = try await URLSession.shared.data(for: retryRequest)
                        let decoded = try JSONDecoder().decode(T.self, from: retryData)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }

            Task {
                if !isRefreshing {
                    isRefreshing = true
                    do {
                        defer { isRefreshing = false }
                        let newToken = try await TokenManager.shared.refreshAccessToken()
                        pendingRequests.forEach { task in Task { try? await task(newToken) } }
                        pendingRequests.removeAll()
                    } catch {
                        continuation.resume(throwing: APIError.unauthorized)
                    }
                }
            }
        }
    }
}
