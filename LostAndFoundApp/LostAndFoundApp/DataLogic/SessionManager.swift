//
//  SessionManager.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 5/3/24.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    private let userIDKey = "userID"

    func saveUserID(_ id: Int) {
        UserDefaults.standard.set(id, forKey: userIDKey)
    }

    func getUserID() -> Int? {
        UserDefaults.standard.integer(forKey: userIDKey)
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: userIDKey)
    }
}
