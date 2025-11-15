//
//  Post.swift
//  Network
//
//  Created by YOO on 2025/11/15.
//

struct Post: Codable, Identifiable, Hashable, Equatable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
