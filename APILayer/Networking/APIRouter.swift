//
//  APIRouter.swift
//  Network
//
//  Created by YOO on 2025/11/08.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

protocol APIRouter {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Encodable? { get }

    func asURLRequest(withAccessToken token: String?) throws -> URLRequest
}

extension APIRouter {
    func asURLRequest(withAccessToken token: String? = nil) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        var mergedHeaders = headers ?? [:]

        if let token = token {
            mergedHeaders["Authorization"] = "Bearer \(token)"
        }

        mergedHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }

        return request
    }
}
