//
//  SearchLogic.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 4/30/24.
//

import Foundation

func filterPosts (for selectedFilter: String, with searchText: String, with posts: [Post]) -> [Post] {
    var result: [Post]

    if selectedFilter == "All" {
        result = posts
    } else {
        result = posts.filter { post in
            post.category == selectedFilter
        }
    }
    
    if !searchText.isEmpty {
        result = result.filter { post in
            post.title.localizedCaseInsensitiveContains(searchText) ||
            post.description.localizedCaseInsensitiveContains(searchText) ||
            post.location.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    return result
}

