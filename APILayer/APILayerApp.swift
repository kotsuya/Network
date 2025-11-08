//
//  APILayerApp.swift
//  APILayer
//
//  Created by YOO on 2025/11/08.
//

import SwiftUI

@main
struct APILayerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PostView(PostViewModel())
            }
        }
    }
}
