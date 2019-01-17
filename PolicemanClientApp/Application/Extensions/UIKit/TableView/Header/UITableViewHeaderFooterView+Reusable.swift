//
//  UITableViewHeaderFooterView+Reusable.swift
//
//

import UIKit

extension UITableViewHeaderFooterView: Reusable {
  @objc static var identifier: String {
    return String(describing: self)
  }
}
