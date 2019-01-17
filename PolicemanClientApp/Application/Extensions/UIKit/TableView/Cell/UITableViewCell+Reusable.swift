//
//  UITableViewCell+Reusable.swift
//
//

import UIKit

extension UITableViewCell: Reusable {
  @objc static var identifier: String {
    return String(describing: self)
  }
}
