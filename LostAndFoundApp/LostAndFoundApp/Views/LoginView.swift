//
//  LoginView.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 4/30/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea(.all)
                VStack {
                    Spacer()
                    
                    Text("LOGIN")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                    
                    Text("Welcome Back")
                        .font(.title2)
                        .foregroundStyle(Color.black)
                        
                    Spacer()
                    
                    TextField("Username", text: $username)
                        .padding()
                        .padding(.leading, 25)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .padding(.horizontal)
                        .overlay(HStack {
                            Image(systemName: "person")
                                .foregroundStyle(Color.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                        })
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
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
                    
                    Button("Login") {
                        NetworkManager.shared.loginUser(username: username, password: password) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let user):
                                    SessionManager.shared.saveUserID(user.id)
                                    isAuthenticated = true
                                    print("Logged in User: \(user.name), ID: \(user.id)")
                                case .failure(let error):
                                    alertMessage = error.localizedDescription
                                    showingAlert = true
                                }
                            }
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .frame(minWidth: 100, maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color(red: 245/255, green: 210/255, blue: 104/255))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding()
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .shadow(radius: 3)
                    Spacer()
                }
            }
        }
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    LoginView(isAuthenticated: .constant(false))
}
