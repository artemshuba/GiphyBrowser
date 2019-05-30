//
//  ImageDetailsViewController.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit
import SwiftyGif

class ImageDetailsViewController : UIViewController {
    private lazy var imageView = UIImageView()
    
    private let interactor: ImageDetailsInteractor
    
    init(interactor: ImageDetailsInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        setupLayout()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViews() {
        title = "Gif details"
        
        view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        
        if
            let previewUrl = interactor.image.gifImage.images.original.url,
            let url = URL(string: previewUrl) {
            imageView.setGifFromURL(url)
        }
    }
}
