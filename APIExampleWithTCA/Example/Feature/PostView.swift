//
//  PostView.swift
//  Network
//
//  Created by YOO on 2025/11/15.
//

import SwiftUI
import Module
import ComposableArchitecture

struct PostView: View {
    let store: StoreOf<PostFeature>
    
    private(set) var isPreview: Bool = false
    
    var body: some View {
        VStack {
            if store.isLoading {
                LoadingView()
            } else {
                contentView
            }
        }
        .navigationTitle("POSTS")
        .task {
            guard !isPreview else { return }
            store.send(.fetchPosts)
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch store.response {
        case .success(let posts):
            if posts.isEmpty {
                EmptyStateView {
                    store.send(.retry)
                }
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(posts) { post in
                            listRow(post)
                            Divider()
                        }
                    }
                }
            }
        case .failure(let error):
            ErrorStateView(message: error.localizedDescription) {
                store.send(.retry)
            }
        case .none:
            EmptyView()
        }
    }
    
    func listRow(_ post: Post) -> some View {
        Button {
            store.send(.selectedId(post.id))
        } label: {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Text(post.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)
                    
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(store.selectedId == post.id ? 90 : 0))
                        .foregroundStyle(.secondary)
                }
                
                if store.selectedId == post.id {
                    Text(post.body)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 5)
                        .transition(.opacity)
                }
            }
            .contentShape(Rectangle())
            .padding()
        }
        .buttonStyle(.plain)
        .animation(.default, value: store.selectedId)
    }
}

#Preview("Sample") {
    NavigationStack {
        PostView(store: .init(initialState: .init(), reducer: {
            PostFeature()
        }))
    }
}

#Preview("Loading") {
    NavigationStack {
        PostView(store: .init(initialState: .init(isLoading: true), reducer: {
            PostFeature()
        }), isPreview: true)
    }
}

#Preview("Empty") {
    @Previewable let posts: [Post] = []
    NavigationStack {
        PostView(store: .init(initialState: .init(response: .success(posts)), reducer: {
            PostFeature()
        }), isPreview: true)
    }
}

#Preview("Error") {
    NavigationStack {
        PostView(store: .init(initialState: .init(response: .failure(PostError.invalidURL)), reducer: {
            PostFeature()
        }), isPreview: true)
    }
}
