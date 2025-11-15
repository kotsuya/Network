//
//  PostClient.swift
//  Network
//
//  Created by YOO on 2025/11/15.
//

import Foundation
import Dependencies

struct PostClient: Sendable {
    var fetch: @Sendable () async throws -> Result<[Post], PostError>
}

extension PostClient: DependencyKey {
    static let liveValue = Self(
        fetch: {
            do {
                let (data, response) = try await URLSession.shared
                    .data(from: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw PostError.httpStatus(code: httpResponse.statusCode)
                }
                guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                    throw PostError.decodeFailed
                }
                return .success(posts)
            } catch {
                throw PostError.invalidURL
            }
        }
    )
}

//extension PostClient: TestDependencyKey {
//    public static let testValue = Self()
//    public static let previewValue = Self()
//}

extension DependencyValues {
    var postClient: PostClient {
        get { self[PostClient.self] }
        set { self[PostClient.self] = newValue }
    }
}
