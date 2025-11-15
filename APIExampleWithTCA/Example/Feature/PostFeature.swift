//
//  PostFeature.swift
//  Network
//
//  Created by YOO on 2025/11/15.
//

import ComposableArchitecture

@Reducer
struct PostFeature {
    @ObservableState
    struct State: Equatable {
        var isLoading: Bool = false
        var response: Result<[Post], PostError>? = nil
        var selectedId: Int? = nil
    }
    
    enum Action: Equatable {
        case fetchPosts
        case retry
        case fetchResponse(Result<[Post], PostError>)
        case selectedId(Int)
    }
    
    @Dependency(\.postClient) var postClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchPosts, .retry:
                state.isLoading = true
                return .run { send in
                    let response = try await postClient.fetch()
                    await send(.fetchResponse(response))
                }
            case .fetchResponse(.success(let posts)):
                state.isLoading = false
                state.response = .success(posts)
                return .none
            case .fetchResponse(.failure(let error)):
                state.isLoading = false
                state.response = .failure(error)
                return .none
            case .selectedId(let postId):
                if state.selectedId == postId {
                    state.selectedId = nil
                } else {
                    state.selectedId = postId
                }
                return .none
            }
        }
    }
}
