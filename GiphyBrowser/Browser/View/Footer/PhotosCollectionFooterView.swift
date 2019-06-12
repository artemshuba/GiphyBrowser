//
//  PhotosCollectionFooterView.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

/// Represents a footer view for photos collection.
/// Contains activity indicator to indicate if we are fetching more photos.
class PhotosCollectionFooterView : UICollectionReusableView {
    // MARK: - Properties: private
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    // MARK: - Properties: public
    
    /// Indicates if we are loading more data.
    var isLoading: Bool {
        get {
            return activityIndicator.isAnimating
        }
        set {
            newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupLayout()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupLayout() {
        addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: topAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupViews() {
    }
}
