//
//  ImagesFetcher.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

enum ImagesFetcherError : Error {
    case noData
    case invalidResponse(Error)
}

protocol ImagesFetcher {
    func fetch(limit: Int, offset: Int, complete: @escaping (Result<ImagesResponse, Error>) -> Void)
}
