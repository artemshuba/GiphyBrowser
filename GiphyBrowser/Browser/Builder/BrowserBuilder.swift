//
//  BrowserBuilder.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

/// Provides method for building BrowserViewController.
class BrowserBuilder {
    /// Builds a BrowserViewController with all dependencies.
    ///
    /// - Returns: BrowserViewController.
    static func build() -> BrowserViewController {
        let fetcher = GiphyImagesFetcher(httpService: .default)
        let interactor = BrowserInteractor(imagesFetcher: fetcher)
        let router = BrowserRouter()
        let viewController = BrowserViewController(interactor: interactor)
        
        router.source = viewController
        interactor.view = viewController
        interactor.router = router
        
        return viewController
    }
}
