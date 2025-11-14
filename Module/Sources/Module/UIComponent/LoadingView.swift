//
//  LoadingView.swift
//  Module
//
//  Created by YOO on 2025/11/15.
//

import SwiftUI

public struct LoadingView: View {
    public init() { }
    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading...")
        }
    }
}
