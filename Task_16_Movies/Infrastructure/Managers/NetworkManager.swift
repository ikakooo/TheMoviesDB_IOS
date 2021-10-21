//
//  NetworkManager.swift
//  Task_16_Movies
//
//  Created by MacBook Pro on 21.10.21.
//

import Foundation


protocol NetworkManagerProtocol: AnyObject {
    func get<T: Codable>(url: String,path:String, queryParams:[String: String], completion: @escaping ((Result<T, Error>) -> Void))
    func post<T: Codable>(url: String,path:String, queryParams:[String: String], body: [String: Any], completion: @escaping ((Result<T, Error>) -> Void))
}

enum MovieError: Error {
    case dataNotFound
}

class NetworkManager: NetworkManagerProtocol {
    
    typealias completionBlock<T: Codable> = ((Result<T, Error>) -> Void)
    
    func get<T: Codable>(url: String,path:String, queryParams:[String: String], completion: @escaping completionBlock<T>) {
        
        guard var fullURL = URL(string: url+path) else { return }
        for (key, value) in queryParams {
            fullURL = fullURL.appending(key, value: value)
        }
        
        
        var urlRequest = URLRequest(url: fullURL)
        urlRequest.httpMethod = "GET" // GET PUT DELETE
        
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data  else {
                completion(.failure(MovieError.dataNotFound))
                return
            }
            
            do {
                
                let decoded = try JSONDecoder().decode(T.self, from: data)
                
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    func post<T: Codable>(url: String,path:String,queryParams:[String: String], body: [String: Any], completion: @escaping completionBlock<T>) {
        
    }
}
