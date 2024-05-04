//
//  SignUpView.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 4/30/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                
                Text("SIGN UP")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                
                Text("Create an account")
                    .font(.title2)
                    .foregroundStyle(Color.black)
                
                Spacer()
                
                TextField("Name", text: $name)
                    .padding()
                    .padding(.leading, 25)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)
                    .overlay(HStack {
                        Image(systemName: "person")
                            .foregroundStyle(Color.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 33)
                    })
                    .autocorrectionDisabled()
                    .shadow(radius: 3)
                
                TextField("Username", text: $username)
                    .padding()
                    .padding(.leading, 25)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)
                    .overlay(HStack {
                        Image(systemName: "person.bubble")
                            .foregroundStyle(Color.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 31)
                    })
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .shadow(radius: 3)
                
                TextField("Email", text: $email)
                    .padding()
                    .padding(.leading, 25)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)
                    .overlay(HStack {
                        Image(systemName: "envelope")
                            .foregroundStyle(Color.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                    })
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .shadow(radius: 3)
                
                SecureField("Password", text: $password)
                    .padding()
                    .padding(.leading, 25)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)
                    .overlay(HStack {
                        Image(systemName: "key")
                            .foregroundStyle(Color.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 33)
                    })
                    .autocorrectionDisabled()
                    .shadow(radius: 3)
                
                Button("Sign Up") {
                    registerUser()
                }
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(minWidth: 100, maxWidth: .infinity)
                .padding(.vertical)
                .background(Color(red: 245/255, green: 210/255, blue: 104/255))
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Sign Up Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .shadow(radius: 3)
                
                Spacer()
            }
        }
        .environment(\.colorScheme, .light)
    }
    
    
    private func registerUser() {
        if name.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty {
            alertMessage = "All fields are required. Please fill in every field."
            showingAlert = true
            return
        }
        NetworkManager.shared.registerUser(name: name, email: email.lowercased(), username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
//                                isAuthenticated = true
                    alertMessage = "User \(user.name) created successfully!"
                    showingAlert = true
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
