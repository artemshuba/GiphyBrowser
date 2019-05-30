//
//  BrowserInteractor.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

private let imagesPerPage = 25

class BrowserInteractor {
    private let imagesFetcher: ImagesFetcher
    private var images: [GifImage] = []
    
    weak var view: BrowserView?
    var router: BrowserRouter?
    
    private(set) var isFetching = false {
        didSet {
            view?.showActivity(isLoading: isFetching && !isFetchingMore)
        }
    }
    
    private(set) var isFetchingMore = false {
        didSet {
            view?.showActivity(isLoadingMore: isFetchingMore)
        }
    }
    
    var canFetchMore: Bool {
        return images.count > 0 && !isFetching
    }
    
    init(imagesFetcher: ImagesFetcher) {
        self.imagesFetcher = imagesFetcher
    }
    
    func start() {
        fetchImages(initialFetch: true)
    }
    
    func numberOfImages() -> Int {
        return images.count
    }
    
    func image(at indexPath: IndexPath) -> GifImage {
        return images[indexPath.row]
    }
    
    func didTapOnImage(at indexPath: IndexPath) {
        let image = self.image(at: indexPath)
        router?.routeToDetails(of: image)
    }
    
    func fetchMore() {
        fetchImages(initialFetch: false)
    }
    
    private func fetchImages(initialFetch: Bool) {
        guard !isFetching else { return }
        
        isFetchingMore = !initialFetch
        isFetching = true
        
        imagesFetcher.fetch(limit: imagesPerPage, offset: images.count) { [weak self] result in
            DispatchQueue.main.async {
                guard let me = self else { return }

                me.isFetchingMore = false
                me.isFetching = false
                
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let response):
                    me.process(images: response.data)
                    me.view?.reload()
                }
            }
        }
    }
    
    private func process(images: [GifImage]) {
        /// Sometimes Giphy doesn't return some preview urls.
        /// So let's filter those images.
        self.images.append(contentsOf: images.filter { $0.images.previewGif.url != nil })
    }
}
