//
//  ErrorStateView.swift
//  Module
//
//  Created by YOO on 2025/11/15.
//

import SwiftUI

public struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void
    
    public init(message: String, retryAction: @escaping () -> Void) {
        self.message = message
        self.retryAction = retryAction
    }
    
    public var body: some View {
        ContentUnavailableView {
            Label("ERROR", systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
        } description: {
            Text(message)
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
