//
//  NetworkManager.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 5/1/24.
//

import Foundation
import UIKit
import Alamofire


class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Requests
    
    func getPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        let getURL = "http://34.145.224.134/api/posts/"
        AF.request(getURL, method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let posts = try decoder.decode([Post].self, from: data)
                    print("Posts loaded successfully: \(posts)")
                    completion(posts, nil)
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil, error)
                }
            case .failure(let error):
                print("Network request error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    func submitPost(title: String, description: String, category: String, location: String, filename: String, user_id: Int, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "http://34.145.224.134/api/posts/\(user_id)/") else {
            completion(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "title": title,
            "description": description,
            "category": category,
            "filename": filename,
            "location": location
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                completion(false, error)
                return
            }
            completion(true, nil)
        }.resume()
    }
    
    
    func loginUser(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "http://34.145.224.134/api/login/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }

            switch httpResponse.statusCode {
            case 200, 201:
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                    return
                }
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case 400:
                completion(.failure(NSError(domain: "Bad request: Missing or invalid parameters", code: 400, userInfo: nil)))
            case 404:
                completion(.failure(NSError(domain: "User not found", code: 404, userInfo: nil)))
            default:
                let message = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: "Login failed: \(message)", code: httpResponse.statusCode, userInfo: nil)))
            }
        }.resume()
    }

    func registerUser(name: String, email: String, username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "http://34.145.224.134/api/signup/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["name": name, "email": email, "username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }

            switch httpResponse.statusCode {
            case 200, 201:
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                    return
                }
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case 400:
                let message = String(data: data ?? Data(), encoding: .utf8) ?? "Missing or invalid parameters"
                completion(.failure(NSError(domain: "Bad request: \(message)", code: 400, userInfo: nil)))
            case 404:
                completion(.failure(NSError(domain: "Not found: The specified resource was not found.", code: 404, userInfo: nil)))
            default:
                let message = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: "Signup failed: \(message)", code: httpResponse.statusCode, userInfo: nil)))
            }
        }.resume()
    }
    
    func fetchUserDetails(userID: Int, completion: @escaping (Result<User, Error>) -> Void) {
        let urlString = "http://34.145.224.134/api/users/\(userID)/"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }

            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                    return
                }
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case 404:
                completion(.failure(NSError(domain: "User not found", code: 404, userInfo: nil)))
            default:
                let errorData = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: "Failed with statusCode: \(httpResponse.statusCode), Error: \(errorData)", code: httpResponse.statusCode, userInfo: nil)))
            }
        }.resume()
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "http://34.145.224.134/api/upload/"
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "Image conversion error", code: -1, userInfo: nil)))
            return
        }

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "pic", fileName: "filename.jpg", mimeType: "image/jpeg")
        }, to: url).response { response in
            guard let httpResponse = response.response else {
                completion(.failure(NSError(domain: "No HTTP response", code: 0, userInfo: nil)))
                return
            }
            
            switch httpResponse.statusCode {
            case 200, 201:
                guard let data = response.data else {
                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                    return
                }
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let filename = jsonData["filename"] as? String {
                        completion(.success(filename))
                    } else {
                        completion(.failure(NSError(domain: "Failed to decode response", code: -1, userInfo: nil)))
                    }
                } catch {
                    completion(.failure(NSError(domain: "JSON decoding error", code: -1, userInfo: nil)))
                }
            case 404:
                completion(.failure(NSError(domain: "Resource not found", code: 404, userInfo: nil)))
            default:
                let message = String(data: response.data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: "Failed with statusCode: \(httpResponse.statusCode), Error: \(message)", code: httpResponse.statusCode, userInfo: nil)))
            }
        }
    }
    
    func updateUser(userID: Int, name: String, email: String, username: String, bio: String, profile_img_url: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "http://34.145.224.134/api/users/\(userID)/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "name": name,
            "email": email,
            "username": username,
            "bio": bio,
            "profile_img_url": profile_img_url
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                    return
                }
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case 404:
                completion(.failure(NSError(domain: "User not found", code: 404, userInfo: nil)))
            default:
                let errorData = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: "Failed with statusCode: \(httpResponse.statusCode), Error: \(errorData)", code: httpResponse.statusCode, userInfo: nil)))
            }
        }.resume()
    }
    
}
