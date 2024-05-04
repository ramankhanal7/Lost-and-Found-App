//
//  User.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 5/1/24.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    var name: String
    var email: String
    var username: String
    var bio: String
    var profile_img_url: String

}

let sampleuser = User(id: 1, name: "Raman", email: "raman.khanal7@gmail.com", username: "ramank7", bio: "somebio", profile_img_url: "profilepic")

