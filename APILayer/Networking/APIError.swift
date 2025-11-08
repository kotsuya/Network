//
//  APIError.swift
//  Network
//
//  Created by YOO on 2025/11/08.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case httpStatus(code: Int)
    case decoding(Error)
    case unauthorized        // 401
    case unknown(Error)
}
