//
//  Untitled.swift
//  Module
//
//  Created by YOO on 2025/11/15.
//

import SwiftUI

public struct EmptyStateView: View {
    let retryAction: () -> Void
    
    public init(retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
    }
    
    public var body: some View {
        ContentUnavailableView {
            Label("Empty Data", systemImage: "list.bullet.clipboard")
        } description: {
            Text("Posts is empty.")
        } actions: {
            if #available(iOS 26.0, *) {
                Button("Retry") {
                    retryAction()
                }
                .buttonStyle(.glassProminent)
            } else {
                Button("Retry") {
                    retryAction()
                }
            }
        }
    }
}
