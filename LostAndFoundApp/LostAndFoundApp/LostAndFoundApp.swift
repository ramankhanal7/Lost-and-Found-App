//
//  LostAndFoundAppApp.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 4/30/24.
//

import SwiftUI

@main
struct LostAndFoundApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var isAuthenticated = false

    var body: some View {
        if isAuthenticated {
            UITabView()
        } else {
            WelcomeView(isAuthenticated: $isAuthenticated)
        }
    }
}
