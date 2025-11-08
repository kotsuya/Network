//
//  PostView.swift
//  Network
//
//  Created by YOO on 2025/11/08.
//

import SwiftUI

struct PostView: View {
    @StateObject private var vm: PostViewModel
    
    @State private(set) var isPreview: Bool
    
    init(_ vm: PostViewModel, isPreview: Bool = false) {
        self._vm = .init(wrappedValue: vm)
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

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading...")
        }
    }
}

struct EmptyStateView: View {
    let retryAction: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label("Empty Data", systemImage: "list.bullet.clipboard")
        } description: {
            Text("Posts is empty.")
        } actions: {
            Button("Retry") {
                retryAction()
            }
            .buttonStyle(.glassProminent)
        }
    }
}

struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label("ERROR", systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
        } description: {
            Text(message)
        } actions: {
            Button("Retry") {
                retryAction()
            }
            .buttonStyle(.glassProminent)
        }
    }
}

#Preview("Sample") {
    NavigationStack {
        PostView(PostViewModel())
    }
}

#Preview("Loading") {
    NavigationStack {
        PostView(PostViewModel(state: .loading), isPreview: true)
    }
}

#Preview("Empty") {
    NavigationStack {
        PostView(PostViewModel(state: .empty), isPreview: true)
    }
}

#Preview("Error") {
    NavigationStack {
        PostView(PostViewModel(state: .failed("ERROR: 401")), isPreview: true)
    }
}
