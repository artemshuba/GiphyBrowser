//
//  HttpService.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

class HttpService {
    static let `default` = HttpService()
    
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
