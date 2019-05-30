//
//  HttpRequest.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

struct HttpRequest {
    private let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func responseData(response: @escaping (Result<Data?, Error>) -> (Void)) {
        perform(request, complete: response)
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
