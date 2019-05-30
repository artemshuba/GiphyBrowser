//
//  ImageDetailsInteractor.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation

class ImageDetailsInteractor {
    private let imagesFetcher: ImagesFetcher
    
    let image: ImageViewModel
    weak var view: ImageDetailsView?
    
    var isFetching = false {
        didSet {
            view?.updateActivity(isLoading: isFetching)
        }
    }
    
    init(image: ImageViewModel, imagesFetcher: ImagesFetcher) {
        self.image = image
        self.imagesFetcher = imagesFetcher
    }
    
    func fetch() {
        isFetching = true
        
        imagesFetcher.fetch(image: image.gifImage, type: .original) { [weak self] result in
            DispatchQueue.main.async {
                guard let me = self else { return }
                
                me.isFetching = false
                
                switch result {
                case .failure(let error):
                    // TODO show alert
                    print(error)
                case .success(let data):
                    me.view?.showImage(with: data)
                }
            }
        }
    }
}
