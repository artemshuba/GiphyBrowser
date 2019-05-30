//
//  ImagesResponse.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

struct ImagesResponse: Decodable {
    var data: [GifImage]
}
