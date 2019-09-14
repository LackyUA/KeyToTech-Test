//
//  NetworkService.swift
//  KeyToTech-Test
//
//  Created by Dima Dobrovolskyy on 9/14/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import Foundation


/// Service for sending requests to API (Singleton).
final class CommentsService {
    
    static let shared = CommentsService()
    
    private let commentsUrl = "http://jsonplaceholder.typicode.com/comments"
    private init() {}
    
    /// Method for fetching and parsing response from API.
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
                
                return
            }
        }.resume()
    }

    /// Method for fetching comments from API.
    func fetchComments(result: @escaping (Result<[Comment], Error>) -> Void) {
        guard let url = URL(string: commentsUrl) else {
            let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid url."]) as Error
            result(.failure(error))
            return
        }
        
        fetchResources(url: url) { (response: Result<[Comment], Error>) in
            switch response {
            case .success(let comments):
                result(.success(comments.sorted(by: { $0.id < $1.id })))
                
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
}
