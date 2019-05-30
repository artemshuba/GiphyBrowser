//
//  GifImage.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

struct GifImage : Decodable {
    let type: String
    let id: String
    let url: String
    let images: GifImages
}

struct GifImages : Decodable {
    let previewGif: GifData
}

struct GifData: Decodable {
    let url: String?
}
