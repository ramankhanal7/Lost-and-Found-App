//
//  WelcomeView.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 4/30/24.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var isAuthenticated: Bool
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea(.all)
                
                VStack {
                    Spacer()
                    Text("Welcome To")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.black)
                    
                    Text("CORNELL UNIVERSITY")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.black)
                    
                    Text("Lost & Found")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.black)
                    
                    NavigationLink(destination: LoginView(isAuthenticated: $isAuthenticated)) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 280, height: 44)
                            .background(Color(red: 245/255, green: 210/255, blue: 104/255))
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .shadow(radius: 3)
                    }
                    .padding()
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 280, height: 44)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .shadow(radius: 3)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }.tint(Color.black)
    }
}

#Preview {
    WelcomeView(isAuthenticated: .constant(false))
}
