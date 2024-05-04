//
//  UserProfileView.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 5/3/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserProfileView: View {
    var user: User?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                if let profileImgUrl = user?.profile_img_url, let url = URL(string: "http://34.145.224.134/api/upload/\(profileImgUrl)") {
                    WebImage(url: url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                } else {
                    Image("defaultProfilePic")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                
                Text(user?.name ?? "Not Loaded")
                    .font(.system(size: 32))
                    .fontWeight(.medium)
                
                Text(user?.username ?? "Not Loaded")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                Text(user?.email ?? "Not Loaded")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.gray)
                
                Text(user?.bio ?? "Not Loaded")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
                
                Spacer()
            }
            .padding(.all, 20)
            .navigationTitle("User Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .environment(\.colorScheme, .light)
    }
}

