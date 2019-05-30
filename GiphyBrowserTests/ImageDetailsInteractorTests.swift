//
//  ImageDetailsInteractorTests.swift
//  GiphyBrowserTests
//
//  Created by Artem Shuba on 30/05/2019.
//

import XCTest
@testable import GiphyBrowser

class ImageDetailsInteractorTests: XCTestCase {

    override func setUp() {
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testImageIsLoaded() {
        // Given
        var expectation: XCTestExpectation?
        let mockImage = GifImage(
            type: "gif",
            id: "1",
            url: "",
            images: GifImages(
                original: GifData(url: ""),
                previewGif: GifData(url: "")))
        var imageData: Data?
        
        let mockView = MockImageDetailsView()
        mockView.onShowImage = { data in
            imageData = data
            expectation?.fulfill()
        }
        
        let interactor = ImageDetailsInteractor(image: ImageViewModel(gifImage: mockImage), imagesFetcher: MockImagesFetcher())
        interactor.view = mockView
        
        expectation = self.expectation(description: "Image data should not be nil")
        
        //When
        interactor.fetch()
        
        //Then
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertNotNil(imageData)
    }
}
