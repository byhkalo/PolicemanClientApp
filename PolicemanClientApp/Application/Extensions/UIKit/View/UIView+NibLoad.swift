//
//  UIView+NibLoad.swift
//
//

import UIKit

internal extension UIView {
  @objc class func viewFromNib(withOwner owner: Any? = nil) -> Self {
    let name = String(describing: type(of: self)).components(separatedBy: ".")[0]
    let view = UINib(nibName: name, bundle: nil).instantiate(withOwner: owner, options: nil)[0]
    return cast(view)!
  }
  @objc func loadFromNibIfEmbeddedInDifferentNib() -> Self {
    let isJustAPlaceholder = subviews.count == 0
    if isJustAPlaceholder {
      let theRealThing = type(of: self).viewFromNib()
      theRealThing.frame = frame
      translatesAutoresizingMaskIntoConstraints = false
      theRealThing.translatesAutoresizingMaskIntoConstraints = false
      return theRealThing
    }
    return self
  }
}

private func cast<T, U>(_ value: T) -> U? {
  return value as? U
}
