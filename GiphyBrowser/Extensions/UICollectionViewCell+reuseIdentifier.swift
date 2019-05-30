//
//  UICollectionViewCell+reuseIdentifier.swift
//  GiphyBrowser
//
//  Created by Artem Shuba on 30/05/2019.
//

import UIKit

extension UICollectionViewCell {
    /// Reuse identifier for cell.
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
