//
//  PostError.swift
//  Network
//
//  Created by YOO on 2025/11/15.
//

enum PostError: Error, Equatable {
    case invalidURL
    case httpStatus(code: Int)
    case decodeFailed
}
