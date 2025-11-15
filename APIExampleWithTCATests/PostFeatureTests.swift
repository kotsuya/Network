//
//  PostFeatureTests.swift
//  NetworkTests
//
//  Created by YOO on 2025/11/15.
//

import ComposableArchitecture
@testable import APIExampleWithTCA
import Testing

@MainActor
struct PostFeatureTests {

    // Mock data
    private let mockPosts: [Post] = [
        Post(id: 0, userId: 0, title: "title0", body: "body0"),
        Post(id: 1, userId: 0, title: "title1", body: "body1"),
    ]

    @Test
    func test_fetchPosts_success() async {
        let store = TestStore(
            initialState: PostFeature.State()
        ) {
            PostFeature()
        } withDependencies: {
            $0.postClient.fetch = {
                .success(self.mockPosts)
            }
        }

        await store.send(.fetchPosts) {
            $0.isLoading = true
        }

        await store.receive(.fetchResponse(.success(mockPosts))) {
            $0.isLoading = false
            $0.response = .success(self.mockPosts)
        }
    }

    @Test
    func test_fetchPosts_failure() async {
        let store = TestStore(
            initialState: PostFeature.State()
        ) {
            PostFeature()
        } withDependencies: {
            $0.postClient.fetch = {
                .failure(PostError.decodeFailed)
            }
        }

        await store.send(.fetchPosts) {
            $0.isLoading = true
        }

        await store.receive(.fetchResponse(.failure(PostError.decodeFailed))) {
            $0.isLoading = false
            $0.response = .failure(PostError.decodeFailed)
        }
    }

    @Test
    func test_retry_callsFetchAgain() async {
        var fetchCount = 0

        let store = TestStore(
            initialState: PostFeature.State()
        ) {
            PostFeature()
        } withDependencies: {
            $0.postClient.fetch = {
                fetchCount += 1
                return .success(self.mockPosts)
            }
        }

        await store.send(.fetchPosts) {
            $0.isLoading = true
        }
        await store.receive(.fetchResponse(.success(mockPosts))) {
            $0.isLoading = false
            $0.response = .success(self.mockPosts)
        }

        await store.send(.retry) {
            $0.isLoading = true
        }
        await store.receive(.fetchResponse(.success(mockPosts))) {
            $0.isLoading = false
            $0.response = .success(self.mockPosts)
        }

        XCTAssertEqual(fetchCount, 2, "fetch() should be called twice (fetch + retry)")
    }

    @Test
    func test_selectedId_toggle() async {
        let store = TestStore(
            initialState: PostFeature.State()
        ) {
            PostFeature()
        }

        await store.send(.selectedId(10)) {
            $0.selectedId = 10
        }

        await store.send(.selectedId(10)) {
            $0.selectedId = nil
        }

        await store.send(.selectedId(20)) {
            $0.selectedId = 20
        }
    }
}
