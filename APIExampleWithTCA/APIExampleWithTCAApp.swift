//
//  APIExampleWithTCAApp.swift
//  APIExampleWithTCA
//
//  Created by YOO on 2025/11/15.
//

import SwiftUI
import ComposableArchitecture

@main
struct APIExampleWithTCAApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PostView(store: .init(initialState: .init(), reducer: {
                    PostFeature()
                }))
            }
        }
    }
}
