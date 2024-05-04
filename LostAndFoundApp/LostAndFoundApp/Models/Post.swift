//
//  Post.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 4/30/24.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let filename: String
    let location: String
    let time: String
    let user_id: Int
}
