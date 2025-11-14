//
//  PostViewStore.swift
//  Network
//
//  Created by YOO on 2025/11/08.
//

import Foundation
import Observation

struct Post: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

enum PostViewState: Equatable {
    case none
    case loading
    case completed([Post])
    case empty
    case failed(String)
}

@MainActor @Observable
final class PostViewStore {
    private(set) var posts: [Post]
    private(set) var state: PostViewState
    var selectedId: Int?
    
    init(posts: [Post] = [], state: PostViewState = .none) {
        self.posts = posts
        self.state = state
    }
    
    func fetchPosts() async {
        state = .loading
        do {
            posts = try await NetworkService.shared.request(PostAPI.fetchAll)
            state = posts.isEmpty ? .empty : .completed(posts)
        } catch {
            print("❌ Error:", error)
            state = .failed(error.localizedDescription)
        }
    }
    
    func retry() {
        Task {
            await fetchPosts()
        }
    }
    
    func selectAction(_ id: Int) {
        guard !posts.isEmpty else { return }
        
        if selectedId == id {
            selectedId = nil
        } else {
            selectedId = id
        }
    }
    
    func isSelected(_ id: Int) -> Bool {
        selectedId == id
    }
}
