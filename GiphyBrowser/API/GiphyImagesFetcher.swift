//
//  GiphyImagesFetcher.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

// TODO should be moved to Configuration class
private let apiBase = "https://api.giphy.com/v1/gifs"
private let apiKey = "uC3CE53LNmWT6Z4x9sBZPIpdhoPgEyGw"

enum ImageFetchType {
    case preview
    case original
}

class GiphyImagesFetcher : ImagesFetcher {
    private let httpService: HttpService
    private let cache: NSCache<NSString, NSData>
    
    init(httpService: HttpService) {
        self.httpService = httpService
        self.cache = NSCache<NSString, NSData>()
    }
    
    func fetch(limit: Int, offset: Int, complete: @escaping (Result<ImagesResponse, Error>) -> Void) {
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
    
    func fetch(image: GifImage, type: ImageFetchType, complete: @escaping (Result<Data, Error>) -> Void) {
        var imageUrl: String?
        
        switch type {
        case .original:
            imageUrl = image.images.original.url
        case .preview:
            imageUrl = image.images.previewGif.url
        }
        
        guard let url = imageUrl else { return }
        
        if let cachedData = cache.object(forKey: NSString(string: url)) {
            complete(.success(Data(referencing: cachedData)))
            return
        }
        
        httpService.request(url: url, parameters: [:]).responseData { [weak self] result in
            switch result {
            case .failure(let error):
                complete(.failure(error))
            case .success(let data):
                guard let imageData = data else {
                    complete(.failure(ImagesFetcherError.noData))
                    return
                }
                
                self?.cache.setObject(NSData(data: imageData), forKey: NSString(string: url))
                complete(.success(imageData))
            }
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
            
            // TODO decoding should be done in a separate class
            
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
