//
//  ImageDetailsViewController.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

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
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViews() {
        title = "Gif details"
        
        view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        
        if let previewUrl = interactor.image.images.previewGif.url,
            let url = URL(string: previewUrl),
            let data = try? Data(contentsOf: url) {
            //TODO load from cache
            imageView.image = UIImage(data: data)
        }
    }
}
