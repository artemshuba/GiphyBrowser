//
//  ImageDetailsViewController.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit
import SwiftyGif

protocol ImageDetailsView : class {
    func updateActivity(isLoading: Bool)
    func showImage(with data: Data)
}

class ImageDetailsViewController : UIViewController {
    private lazy var imageView = UIImageView()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    private let interactor: ImageDetailsInteractor
    
    init(interactor: ImageDetailsInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupViews()
        
        interactor.fetch()
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(activityIndicator)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViews() {
        title = "Gif details"
        
        view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        
        activityIndicator.hidesWhenStopped = true
    }
}

extension ImageDetailsViewController : ImageDetailsView {
    func updateActivity(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func showImage(with data: Data) {
        guard let image = try? UIImage(gifData: data) else { return }
        imageView.setGifImage(image)
    }
}
