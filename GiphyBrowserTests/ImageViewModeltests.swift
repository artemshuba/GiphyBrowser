//
//  ImageViewModeltests.swift
//  GiphyBrowserTests
//
//  Created by Artem Shuba on 30/05/2019.
//

import XCTest
@testable import GiphyBrowser

class ImageViewModelTests: XCTestCase {
    let imageFetcher = MockImagesFetcher()
    
    override func setUp() {

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testImageViewModelOnUpdate() {
        // Given
        var expectation: XCTestExpectation?
        let image = GifImage(type: "gif",
                             id: "1",
                             url: "",
                             images: GifImages(original: GifData(url: ""), previewGif: GifData(url: "")))
        let imageViewModel = ImageViewModel(gifImage: image)
        imageViewModel.onUpdate = { data in
            expectation?.fulfill()
        }
        
        let fetchHandler: (Result<Data, Error>) -> Void = { result in
            if case let .success(data) = result {
                imageViewModel.imageData = data
            }
        }
        
        expectation = self.expectation(description: "Image data should not be nil and onUpdate should be called")
        
        //When
        imageFetcher.fetch(image: image, type: .original, complete: fetchHandler)
        
        //Then
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertNotNil(imageViewModel.imageData)
    }
}
