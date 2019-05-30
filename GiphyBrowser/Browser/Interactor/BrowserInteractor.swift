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
    private var images: [ImageViewModel] = []
    
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
    
    func image(at indexPath: IndexPath) -> ImageViewModel {
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
        
        imagesFetcher.fetch(limit: imagesPerPage, offset: images.count + 1) { [weak self] result in
            DispatchQueue.main.async {
                guard let me = self else { return }

                me.isFetchingMore = false
                me.isFetching = false
                
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let response):
                    me.process(images: response.data)
                }
            }
        }
    }
    
    private func fetchImage(for viewModel: ImageViewModel) {
        imagesFetcher.fetch(image: viewModel.gifImage) { result in
            guard case let .success(data) = result else { return }
            viewModel.imageData = data
        }
    }
    
    private func process(images: [GifImage]) {
        let startingIndex = self.images.count
        var indexPaths: [IndexPath] = []
        var imageViewModels: [ImageViewModel] = []
        
        /// Sometimes Giphy doesn't return some preview urls.
        /// So let's filter those images.
        imageViewModels = images.filter{ $0.images.previewGif.url != nil }.map { ImageViewModel(gifImage: $0)}
        
        for imageVM in imageViewModels {
            fetchImage(for: imageVM)
        }
                
        self.images.append(contentsOf: imageViewModels)
        
        for i in startingIndex..<self.images.count {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        
        view?.insertItems(at: indexPaths)
    }
}
