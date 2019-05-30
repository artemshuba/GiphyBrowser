//
//  BrowserInteractorTests.swift
//  GiphyBrowserTests
//
//  Created by Artem Shuba on 30/05/2019.
//

import XCTest
@testable import GiphyBrowser

class BrowserInteractorTests: XCTestCase {
    let imageFetcher = MockImagesFetcher()
    let mockView = MockBrowserView()
    lazy var interactor = BrowserInteractor(imagesFetcher: imageFetcher)
    
    override func setUp() {
        var mockImages: [GifImage] = []
        
        for i in 0..<50 {
            mockImages.append(GifImage(
                type: "gif",
                id: "\(i)",
                url: "https://giphy.com/gifs/snl-saturday-night-live-season-44-giuaF7FQqGIP0fBSwA",
                images: GifImages(
                    original: GifData(url: "https://giphy.com/gifs/snl-saturday-night-live-season-44-giuaF7FQqGIP0fBSwA"),
                    previewGif: GifData(url: "https://media2.giphy.com/media/giuaF7FQqGIP0fBSwA/giphy_s.gif"))))
        }

        
        imageFetcher.images = mockImages
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        imageFetcher.images = []
    }
    
    func test25ImagesFetched() {
        //Given
        var expectation: XCTestExpectation?
        
        mockView.onItemsInserted = { indexPaths in
            expectation?.fulfill()
        }
        
        expectation = self.expectation(description: "Interactor should load 25 images")
        
        //When
        interactor.view = mockView
        interactor.fetch()
        
        //Then
        waitForExpectations(timeout: 2, handler: nil)
        let fetchedImagesCount = interactor.numberOfImages()
        
        XCTAssertEqual(fetchedImagesCount, 25)
    }
    
    func test25ImagesFetchedMore() {
        //Given
        var expectation: XCTestExpectation?
        var isFetchedMore = false
        
        mockView.onItemsInserted = { indexPaths in
            if isFetchedMore {
                expectation?.fulfill()
            } else {
                isFetchedMore = true
                self.interactor.fetchMore()
            }
        }
        
        expectation = self.expectation(description: "Interactor should load 50 images")
        
        //When
        interactor.view = mockView
        interactor.fetch()
        
        //Then
        waitForExpectations(timeout: 4, handler: nil)
        let fetchedImagesCount = interactor.numberOfImages()
        
        XCTAssertEqual(fetchedImagesCount, 50)
    }
    
    func testFetchActivityIsUpdated() {
        //Given
        var isLoadingImages: Bool = false
        var expectation: XCTestExpectation?
        
        mockView.onShowIsLoadingActivity = { isLoading in
            isLoadingImages = isLoading
        }
        
        mockView.onItemsInserted = { _ in
            expectation?.fulfill()
        }

        expectation = self.expectation(description: "Interactor should set isLoading to false")
        
        //When
        interactor.view = mockView
        interactor.fetch()
        
        //Then
        XCTAssertEqual(isLoadingImages, true)
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertEqual(isLoadingImages, false)
    }
}
