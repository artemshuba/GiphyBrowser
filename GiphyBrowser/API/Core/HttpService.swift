//
//  HttpService.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

/// A service to perform HTTP requests.
class HttpService {
    /// Provides a default instance of HttpService.
    static let `default` = HttpService()
    
    /// Creates and returns a GET HttpRequest with given url and parameters.
    ///
    /// - Parameter url: An url string.
    /// - Parameter parameters: A dictionary with query parameters.
    func request(url: String, parameters: [String : String]) -> HttpRequest {
        guard var urlComponents = URLComponents(string: url) else {
            /// Should never happen.
            fatalError("Invalid url.")
        }
        
        urlComponents.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        guard let url = urlComponents.url else {
            /// Should never happen.
            fatalError("Unable to format url with given parameters.")
        }
        
        let urlRequest = URLRequest(url: url)
        return HttpRequest(request: urlRequest)
    }
}
