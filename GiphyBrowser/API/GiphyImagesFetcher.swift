//
//  GiphyImagesFetcher.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

private let apiBase = "https://api.giphy.com/v1/gifs"
private let apiKey = "vq8aNGnBmV6i6ey95bRZxS0CWrkYbtq2"

class GiphyImagesFetcher : ImagesFetcher {
    private let httpService: HttpService
    
    init(httpService: HttpService) {
        self.httpService = httpService
    }
    
    func fetch(limit: Int, offset: Int, complete: @escaping (Result<ImagesResponse, Error>) -> Void) {
        //https://api.giphy.com/v1/gifs/trending?api_key=vq8aNGnBmV6i6ey95bRZxS0CWrkYbtq2&limit=25&rating=G
        let parameters = [
            "limit": "\(limit)",
            "offset": "\(offset)",
            "apiKey": "\(apiKey)"
        ]
        
        httpService.request(
            url: "\(apiBase)/trending",
            parameters: parameters).responseData { [weak self] result in
                self?.handle(result: result, complete: complete)
        }
    }
    
    private func handle<T>(result: Result<Data?, Error>,
                                   complete: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        switch result {
        case .failure(let error):
            complete(.failure(error))
        case .success(let data):
            guard let data = data else {
                complete(.failure(ImagesFetcherError.noData))
                return
            }
            
            print("Response: \(String(data: data, encoding: .utf8) ?? "")")
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let response = try decoder.decode(T.self, from: data)
                complete(.success(response))
            } catch {
                complete(.failure(ImagesFetcherError.invalidResponse(error)))
            }
            
            break
        }
    }
}
