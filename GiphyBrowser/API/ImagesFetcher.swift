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

/// Provides methods for fetching images.
protocol ImagesFetcher {
    /// Fetches images.
    ///
    /// - Parameters:
    ///   - limit: A number of images to return.
    ///   - offset: An offset from which images should be requested.
    ///   - complete: A closure to handle result.
    func fetch(limit: Int, offset: Int, complete: @escaping (Result<ImagesResponse, Error>) -> Void)
    
    /// Fetches single image as Data.
    ///
    /// - Parameters:
    ///   - image: An image to fetch.
    ///   - type: Type of image. Could be preview or original.
    ///   - complete: A closure to handle result.
    func fetch(image: GifImage, type: ImageFetchType, complete: @escaping (Result<Data, Error>) -> Void)
}
