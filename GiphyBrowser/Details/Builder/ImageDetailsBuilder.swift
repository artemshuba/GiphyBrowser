//
//  ImageDetailsBuilder.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

class ImageDetailsBuilder {
    static func build(with image: ImageViewModel) -> ImageDetailsViewController {
        let fetcher = GiphyImagesFetcher(httpService: .default)
        let interactor = ImageDetailsInteractor(image: image, imagesFetcher: fetcher)
        let viewController = ImageDetailsViewController(interactor: interactor)
        interactor.view = viewController
        
        return viewController
    }
}
