//
//  APIManager.swift
//  APIManagerExample
//
//  Created by Shane Bersiek on 7/29/21.
//

import Foundation

struct APIManager {
   
    enum HttpMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }
    
    fileprivate let baseUrl = "https://jsonplaceholder.typicode.com"
    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "jsonplaceholder.typicode.com"
        return urlComponents
    }
    
    func fetchAllPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
        var urlComponents = self.urlComponents
        urlComponents.path = "/posts"
        guard let url = urlComponents.url else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data!)
                    completion(.success(posts))
                } catch let jsonError {
                    completion(.failure(jsonError))
                }
            }.resume()
        }
    }
    
    func createPost(with post: Post, completion: @escaping (Result<Post, Error>) -> ()) {
        var urlComponents = self.urlComponents
        urlComponents.path = "/posts"
        guard let url = urlComponents.url else { return }
        let postJson = try! JSONEncoder().encode(post)
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.httpBody = postJson
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                do {
                    let post = try JSONDecoder().decode(Post.self, from: data!)
                    completion(.success(post))
                } catch let error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    func patchPost(id: Int, params: [String: Any], completion: @escaping (Result<Post, Error>) -> ()) {
        var urlComponents = self.urlComponents
        urlComponents.path = "/posts/\(id)"
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.patch.rawValue.uppercased()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted])
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                do {
                    let post = try JSONDecoder().decode(Post.self, from: data!)
                    completion(.success(post))
                } catch let error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}
