//
//  UICollectionViewCell+Reusable.swift
//
//

import UIKit

extension UICollectionReusableView: Reusable {
  @objc static var identifier: String {
    return String(describing: self)
  }
}
