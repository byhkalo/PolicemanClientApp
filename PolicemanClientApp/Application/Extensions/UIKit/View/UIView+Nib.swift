//
//  UIView+Nib.swift
//
//

import Foundation
import UIKit

extension UIView {
  @objc static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
  static func instantiateFromNib<ViewType: UIView>(withName initialNibName: String? = nil) -> ViewType {
    var result: ViewType?
    let nibName = initialNibName ?? String(describing: self)
    if let views = Bundle.main.loadNibNamed(nibName, owner: self, options: nil) {
      if views.count > 0 {
        result = views.first as? ViewType
      }
    }
    return result!
  }
}
