//
//  ImageCellViewModel.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

class ImageViewModel {
    let gifImage: GifImage
    
    var imageData: Data? {
        didSet {
            onUpdate?(imageData)
        }
    }
    
    var onUpdate: ((Data?) -> ())?
    
    init(gifImage: GifImage) {
        self.gifImage = gifImage
    }
}
