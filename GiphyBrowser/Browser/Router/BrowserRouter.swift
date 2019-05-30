//
//  BrowserRouter.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

class BrowserRouter {
    weak var source: UIViewController?
    
    func routeToDetails(of image: ImageViewModel) {
        let targetViewController = ImageDetailsBuilder.build(with: image)
        source?.navigationController?.pushViewController(targetViewController, animated: true)
    }
}
