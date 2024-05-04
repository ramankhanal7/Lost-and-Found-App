//
//  HomeScreenView.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 4/30/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeScreenView: View {
    let filters = ["All", "Found", "Lost"]
    @StateObject private var viewModel = HomeScreenViewModel()
    @State private var selectedFilter: String = "All"
    @State private var searchText = ""
    @State private var showingProfile = false
    @State private var selectedUser: User?

    private var filteredPosts: [Post] {
        filterPosts(for: selectedFilter, with: searchText, with: viewModel.posts)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(filters, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .shadow(radius: 3)

                ScrollView {
                    ForEach(filteredPosts) { post in
                        Button(action: {
                            viewModel.getUserById(post.user_id) { result in
                                switch result {
                                case .success(let user):
                                    self.selectedUser = user
                                case .failure(let error):
                                    print("Error loading user: \(error.localizedDescription)")
                                    self.selectedUser = nil
                                }
                            }
                        }) {
                            PostView(post: post)
                        }
                        .sheet(item: $selectedUser) { user in
                            UserProfileView(user: user)
                        }
                    }
                }
                
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for your stuff...")
        }
        .onAppear {
            viewModel.loadPosts()
        }
        .environment(\.colorScheme, .light)
    }
}

struct PostView: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("UserID \(post.user_id)")
                .font(.headline)
                .padding(.leading, 6)
            HStack {
                Text(post.category)
                    .fontWeight(.bold)
                    .foregroundStyle(post.category == "Lost" ? Color.red : Color.green)
                    .padding(.leading, post.category == "Lost" ? 7 : 0)
                Spacer()
                Text(post.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            WebImage(url: URL(string: "http://34.145.224.134/api/upload/\(post.filename)"))
                .resizable()
                .scaledToFill()
                .frame(width: 325, height: 325)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 22))
            
            HStack {
                Text(post.title)
                    .font(.headline)
                Spacer()
                Text(timeAgo(from: parseDate(from: post.time) ?? Date()))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Text(post.description)
                .font(.body)
                .padding(.top, 2)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(radius: 2)
        .padding([.horizontal, .top])
    }
}


#Preview {
    HomeScreenView()
}
