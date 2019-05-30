//
//  MockImageDetailsView.swift
//  GiphyBrowserTests
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation
@testable import GiphyBrowser

class MockImageDetailsView : ImageDetailsView {
    var onUpdateActivity: ((Bool) -> Void)?
    var onShowImage: ((Data) -> Void)?
    
    func updateActivity(isLoading: Bool) {
        onUpdateActivity?(isLoading)
    }
    
    func showImage(with data: Data) {
        onShowImage?(data)
    }
}
