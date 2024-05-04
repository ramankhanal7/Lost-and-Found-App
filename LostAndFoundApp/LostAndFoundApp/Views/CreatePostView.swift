//
//  CreatePostView.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 4/30/24.
//

import SwiftUI

struct CreatePostView: View {
    @StateObject private var viewModel = CreatePostViewModel()
    @State private var category = "Lost"
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var image: UIImage?
    @State private var image_id = ""
    @State private var showImagePicker = false


    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Category")) {
                    Picker("Type", selection: $category) {
                        Text("Lost").tag("Lost")
                        Text("Found").tag("Found")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }

                Section(header: Text("Description")) {
                    TextField("Enter description", text: $description)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }

                Section(header: Text("Location")) {
                    TextField("Enter location", text: $location)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                Section(header: Text("Upload Image")) {
                    Button("Take Picture") {
                        self.showImagePicker = true
                    }
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }

                Section {
                    Button("Submit Post") {
                        guard let image = image else {
                            alertMessage = "Please take a picture before submitting."
                            showingAlert = true
                            return
                        }
                        viewModel.uploadImageAndCreatePost(image: image, title: title, description: description, category: category, location: location, user_id: SessionManager.shared.getUserID() ?? 0) { success in
                            if success {
                                title = ""
                                description = ""
                                location = ""
                                self.image = nil
                                alertMessage = "Post created successfully!"
                            } else {
                                alertMessage = viewModel.submissionMessage ?? "Failed to create post."
                            }
                            showingAlert = true
                        }
                    }
                }
            }
            .navigationBarTitle("Create Post")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: self.$image)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .environment(\.colorScheme, .light)
    }

    private func submitPost() {
        guard !title.isEmpty, !description.isEmpty, !location.isEmpty
        else {
            alertMessage = "All field must be filled and an image must be taken."
            showingAlert = true
            return
        }
        alertMessage = "Post created successfully!"
        showingAlert = true
        
        title = ""
        description = ""
        location = ""
        image = nil
    }
}


#Preview {
    CreatePostView()
}
