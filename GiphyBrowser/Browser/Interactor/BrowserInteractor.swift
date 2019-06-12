//
//  BrowserInteractor.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

private let imagesPerPage = 25

class BrowserInteractor {
    // MARK: - Properties: private
    private let imagesFetcher: ImagesFetcher
    private var images: [ImageViewModel] = []
    
    weak var view: BrowserView?
    var router: BrowserRouter?
    
    private(set) var isFetching = false {
        didSet {
            view?.updateActivity(isLoading: isFetching && !isFetchingMore)
        }
    }
    
    private(set) var isFetchingMore = false {
        didSet {
            view?.updateActivity(isLoadingMore: isFetchingMore)
        }
    }
    
    // MARK: - Properties: public
    
    var canFetchMore: Bool {
        return images.count > 0 && !isFetching
    }
    
    // MARK: - Init
    
    init(imagesFetcher: ImagesFetcher) {
        self.imagesFetcher = imagesFetcher
    }
    
    // MARK: - Public
    
    func fetch() {
        fetchImages(initialFetch: true)
    }
    
    func fetchMore() {
        fetchImages(initialFetch: false)
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
    
    // MARK: - Private
    
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
                    // TODO show alert
                    print(error)
                case .success(let response):
                    me.process(images: response.data)
                }
            }
        }
    }
    
    private func fetchImage(for viewModel: ImageViewModel) {
        imagesFetcher.fetch(image: viewModel.gifImage, type: .preview) { result in
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
        imageViewModels = images.filter { $0.images.previewGif.url != nil }.map { ImageViewModel(gifImage: $0) }
        
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
