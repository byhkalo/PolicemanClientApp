//
//  XibView.swift
//  BeaconMuseum
//
//  Created by Konstantyn Byhkalo on 6/30/17.
//  Copyright © 2017 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class XibView: UIView {
  var contentView: UIView?
  @IBInspectable var nibName: String?
  override func awakeFromNib() {
    super.awakeFromNib()
    xibSetup()
  }
  func xibSetup() {
    guard let view = loadViewFromNib() else { return }
    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)
    contentView = view
  }
  func loadViewFromNib() -> UIView? {
    guard let nibName = nibName else { return nil }
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName, bundle: bundle)
    return nib.instantiate(
      withOwner: self,
      options: nil).first as? UIView
  }
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    xibSetup()
    contentView?.prepareForInterfaceBuilder()
  }
}
