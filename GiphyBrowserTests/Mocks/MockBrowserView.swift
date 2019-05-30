//
//  MockBrowserView.swift
//  GiphyBrowserTests
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation
@testable import GiphyBrowser

class MockBrowserView : BrowserView {
    var onItemsInserted: (([IndexPath]) -> Void)?
    var onShowIsLoadingActivity: ((Bool) -> Void)?
    var onShowIsLoadingMoreActivity: ((Bool) -> Void)?
    
    func insertItems(at indexPaths: [IndexPath]) {
        onItemsInserted?(indexPaths)
    }
    
    func updateActivity(isLoading: Bool) {
        onShowIsLoadingActivity?(isLoading)
    }
    
    func updateActivity(isLoadingMore: Bool) {
        onShowIsLoadingMoreActivity?(isLoadingMore)
    }
}
