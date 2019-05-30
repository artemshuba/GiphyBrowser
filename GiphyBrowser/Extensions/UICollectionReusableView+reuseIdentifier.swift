//
//  UICollectionReusableView+reuseIdentifier.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

extension UICollectionReusableView {
    /// Reuse identifier for view.
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
