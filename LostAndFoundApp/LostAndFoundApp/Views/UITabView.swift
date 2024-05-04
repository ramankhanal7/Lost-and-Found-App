//
//  UITabView.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 4/30/24.
//

import SwiftUI

struct UITabView: View {
    var body: some View {
        TabView {
            HomeScreenView()
                .environmentObject(HomeScreenViewModel())
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tint(Color.black)
            
            CreatePostView()
                .tabItem {
                    Label("Create", systemImage: "plus.circle")
                }
                .tint(Color.blue)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tint(Color.blue)
        }
        .tint(Color.black)
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    UITabView()
}
