//
//  BrowserRouter.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

/// Provides routes from BrowserViewController.
class BrowserRouter {
    weak var source: UIViewController?
    
    /// Navigates to image details.
    ///
    /// - Parameter image: Image view model.
    func routeToDetails(of image: ImageViewModel) {
        let targetViewController = ImageDetailsBuilder.build(with: image)
        source?.navigationController?.pushViewController(targetViewController, animated: true)
    }
}
