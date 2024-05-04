//
//  ProfileView.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 4/30/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                VStack (alignment: .center, spacing: 20) {
                    ProgressView()
                }
            } else if let user = viewModel.user {
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        Button(action: {
                            viewModel.showImagePicker = true
                        }) {
                            if let editedImage = viewModel.editedImage {
                                Image(uiImage: editedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            }
                        }
                        .sheet(isPresented: $viewModel.showImagePicker, onDismiss: viewModel.uploadImageAndUpdateProfile) {
                            ImagePicker(image: $viewModel.editedImage)
                        }

                        if viewModel.isEditing {
                            TextField("Name", text: $viewModel.editedName)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(5)
                            TextField("Username", text: $viewModel.editedUsername)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(5)
                            TextField("Email", text: $viewModel.editedEmail)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(5)
                            TextEditor(text: $viewModel.editedBio)
                                .frame(height: 200)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(5)
                        } else {
                            Text(user.name)
                            Text(user.username)
                            Text(user.email)
                            Text(user.bio)
                        }

                        if viewModel.isEditing {
                            Button("Save Changes", action: viewModel.uploadImageAndUpdateProfile)
                            Button("Cancel", action: viewModel.cancelEditing)
                        } else {
                            Button("Edit Profile", action: viewModel.startEditing)
                            Button("Logout", action: SessionManager.shared.logout)
                        }

                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            }
        }
        .onAppear(perform: viewModel.loadUserProfile)
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    ProfileView()
}

