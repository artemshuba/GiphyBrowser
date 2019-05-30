//
//  BrowserViewController.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

private let itemSize = CGSize(width: 44, height: 44)
private let maxItemsInRow = 4

protocol BrowserView : class {
    func reload()
}

class BrowserViewController : UIViewController {
    private lazy var imagesCollectionViewLayout = UICollectionViewFlowLayout()
    private lazy var imagesCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: imagesCollectionViewLayout)
    
    private let interactor: BrowserInteractor

    init(interactor: BrowserInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        setupLayout()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupLayout() {
        view.addSubview(imagesCollectionView)
        
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            imagesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupViews() {
        title = "Browser"
        view.backgroundColor = .white
        
        imagesCollectionViewLayout.minimumInteritemSpacing = 1
        imagesCollectionViewLayout.minimumLineSpacing = 1
        updateCollectionItemSize()
        
        imagesCollectionView.register(BrowserImageCell.self, forCellWithReuseIdentifier: BrowserImageCell.reuseIdentifier)
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
}

extension BrowserViewController : BrowserView {
    func reload() {
        imagesCollectionView.reloadData()
    }
}
