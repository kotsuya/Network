//
//  PostView.swift
//  Network
//
//  Created by YOO on 2025/11/08.
//

import SwiftUI
import Module

struct PostView: View {
    private var vm: PostViewStore
    
    private(set) var isPreview: Bool
    
    init(_ vm: PostViewStore, isPreview: Bool = false) {
        self.vm = vm
        self.isPreview = isPreview
    }
    
    var body: some View {
        contentView
            .navigationTitle("POSTS")
            .task {
                guard !isPreview else { return }
                await vm.fetchPosts()
            }
    }
    
    var contentView: some View {
        VStack {
            switch vm.state {
            case .none:
                EmptyView()
            case .loading:
                LoadingView()
            case .completed(let posts):
                ScrollView {
                    LazyVStack {
                        ForEach(posts) { post in
                            listRow(post)
                            Divider()
                        }
                    }
                }
            case .empty:
                EmptyStateView {
                    vm.retry()
                }
            case .failed(let message):
                ErrorStateView(message: message) {
                    vm.retry()
                }
            }
        }
    }
    
    func listRow(_ post: Post) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                vm.selectAction(post.id)
            }
        } label: {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Text(post.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)
                    
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(vm.isSelected(post.id) ? 90 : 0))
                        .foregroundStyle(.secondary)
                }
                
                if vm.isSelected(post.id) {
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
    }
}

#Preview("Sample") {
    NavigationStack {
        PostView(PostViewStore())
    }
}

#Preview("Loading") {
    NavigationStack {
        PostView(PostViewStore(state: .loading), isPreview: true)
    }
}

#Preview("Empty") {
    NavigationStack {
        PostView(PostViewStore(state: .empty), isPreview: true)
    }
}

#Preview("Error") {
    NavigationStack {
        PostView(PostViewStore(state: .failed("ERROR: 401")), isPreview: true)
    }
}
