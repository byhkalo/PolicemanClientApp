//
//  Reusable.swift
//  
//

import UIKit

protocol Reusable {
  static var identifier: String { get }
  static var nib: UINib { get }
}

extension Reusable {
  static var identifier: String {
    return String(describing: self)
  }
}
