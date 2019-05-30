//
//  BrowserInteractor.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

class BrowserInteractor {
    private let imagesFetcher: ImagesFetcher
    private var images: [GifImage] = []
    
    weak var view: BrowserView?
    var router: BrowserRouter?
    
    init(imagesFetcher: ImagesFetcher) {
        self.imagesFetcher = imagesFetcher
    }
    
    func start() {
        fetchImages()
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
    
    private func fetchImages() {
        imagesFetcher.fetch(limit: 25, offset: 0) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let response):
                    self?.images = response.data
                    self?.view?.reload()
                }
            }
        }
    }
}
