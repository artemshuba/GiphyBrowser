//
//  BrowserImageCell.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

class BrowserImageCell : UICollectionViewCell {
    private lazy var imageView = UIImageView()
    
    var imageViewModel: ImageViewModel? {
        didSet {
            /// Show the actual data if it's already fetched.
            update(imageData: imageViewModel?.imageData)
            /// Subscribe for image data updates.
            imageViewModel?.onUpdate = { [weak self] data in
                self?.update(imageData: data)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func update(imageData: Data?) {
        guard let data = imageData else {
            self.imageView.image = nil
            return
        }
        
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
        }
    }
}
