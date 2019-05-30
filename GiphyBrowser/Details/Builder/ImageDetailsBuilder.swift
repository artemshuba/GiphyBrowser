//
//  ImageDetailsBuilder.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

class ImageDetailsBuilder {
    static func build(with image: GifImage) -> ImageDetailsViewController {
        let interactor = ImageDetailsInteractor(image: image)
        let viewController = ImageDetailsViewController(interactor: interactor)
        
        return viewController
    }
}
