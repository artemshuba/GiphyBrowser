//
//  ImageCellViewModel.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

/// A view model for image.
class ImageViewModel {
    /// An image model.
    let gifImage: GifImage
    
    /// An actual image data. Used for displaying an image.
    /// Image data will be assigned separately after image will be fetched.
    var imageData: Data? {
        didSet {
            onUpdate?(imageData)
        }
    }
    
    /// Notifies the view that image data has been updated and should be displayed.
    var onUpdate: ((Data?) -> ())?
    
    init(gifImage: GifImage) {
        self.gifImage = gifImage
    }
}
