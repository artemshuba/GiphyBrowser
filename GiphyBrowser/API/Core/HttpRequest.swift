//
//  HttpRequest.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

/// Represents HTTP request.
struct HttpRequest {
    private let request: URLRequest
    
    /// Initializes HttpRequest with provided URLRequest.
    init(request: URLRequest) {
        self.request = request
    }
    
    /// Performs a request and returns response as Data.
    ///
    /// - Parameter complete: A closure to handle a response.
    func responseData(complete: @escaping (Result<Data?, Error>) -> (Void)) {
        perform(request, complete: complete)
    }
    
    private func perform(_ request: URLRequest, complete: @escaping (Result<Data?, Error>) -> ()) {
        print("Request: \(request.url?.absoluteString ?? "")")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                complete(.failure(error))
                return
            }
            
            complete(.success(data))
        }
        
        task.resume()
    }
}
