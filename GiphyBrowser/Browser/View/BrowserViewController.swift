//
//  BrowserViewController.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

private let maxItemsInRow = 4

protocol BrowserView : class {
    func reload()
    func showActivity(isLoading: Bool)
    func showActivity(isLoadingMore: Bool)
}

class BrowserViewController : UIViewController {
    private lazy var imagesCollectionViewLayout = UICollectionViewFlowLayout()
    private lazy var imagesCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: imagesCollectionViewLayout)
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    private let interactor: BrowserInteractor

    init(interactor: BrowserInteractor) {
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
        
        interactor.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupLayout() {
        view.addSubview(imagesCollectionView)
        view.addSubview(activityIndicator)
        
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupViews() {
        title = "Trending"
        view.backgroundColor = .white
        
        activityIndicator.hidesWhenStopped = true
        
        imagesCollectionViewLayout.minimumInteritemSpacing = 1
        imagesCollectionViewLayout.minimumLineSpacing = 1
        updateCollectionItemSize()
        
        imagesCollectionView.register(BrowserImageCell.self,
                                      forCellWithReuseIdentifier: BrowserImageCell.reuseIdentifier)
        imagesCollectionView.register(PhotosCollectionFooterView.self,
                                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                      withReuseIdentifier: PhotosCollectionFooterView.reuseIdentifier)
        
        imagesCollectionView.backgroundColor = .white
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
    }
    
    private func updateCollectionItemSize() {
        let itemSize = view.frame.width / CGFloat(maxItemsInRow) - imagesCollectionViewLayout.minimumInteritemSpacing
        imagesCollectionViewLayout.itemSize = CGSize(width: itemSize, height: itemSize)
    }
}

extension BrowserViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor.numberOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowserImageCell.reuseIdentifier,
                                                            for: indexPath) as? BrowserImageCell else {
                                                                fatalError("Unexpected cell type.")
        }
        
        let image = interactor.image(at: indexPath)
        if let previewUrl = image.images.previewGif.url,
            let url = URL(string: previewUrl),
            let data = try? Data(contentsOf: url) {
            //TODO asynchronius loading
            cell.image = UIImage(data: data)
        }
        return cell
    }
}

extension BrowserViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.didTapOnImage(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let photosCollectionFooterView = view as? PhotosCollectionFooterView else { return }
        
        interactor.fetchMore()
        
        photosCollectionFooterView.isLoading = interactor.isFetchingMore
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard let photosCollectionFooterView = view as? PhotosCollectionFooterView else { return }
        
        photosCollectionFooterView.isLoading = false
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PhotosCollectionFooterView.reuseIdentifier, for: indexPath)
    }
}

extension BrowserViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard interactor.canFetchMore else { return CGSize.zero }
        
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

extension BrowserViewController : BrowserView {
    func reload() {
        imagesCollectionView.reloadData()
    }
    
    func showActivity(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func showActivity(isLoadingMore: Bool) {
        guard let footerView = imagesCollectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter).first as? PhotosCollectionFooterView else { return }
        
        footerView.isLoading = isLoadingMore
    }
}
