//
//  UIView+Extensions.swift
//
//

import UIKit

extension UIView {

  enum ConstraintsType {
    case fillToEdge(UIEdgeInsets)
    case fixToCenter
    case fixToTop
  }

  func addSubview(_ subview: UIView, with constraintsType: ConstraintsType) {
    switch constraintsType {
    case .fillToEdge(let edgeInsets):
      addSubviewWithDefaultConstraints(subview, edgeInsets: edgeInsets)
    case .fixToCenter:
      addSubviewWithCenterConstraints(subview)
    case .fixToTop:
      addSubviewWithTopConstraints(subview)
    }
  }

  @objc func scale(width: Double = 1, height: Double = 1) {
    transform = CGAffineTransform(scaleX: CGFloat(width), y: CGFloat(height))
  }

  @objc func rounding() {
    layer.cornerRadius = frame.size.width / 2
    layer.masksToBounds = true
  }

  @objc func applyCorner(_ radius: CGFloat) {
    layer.cornerRadius = radius
    layer.masksToBounds = true
  }
  @objc func applyCellShadowAndCorner() {
    applyCorner(8.0)
    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 8.0
  }
  @objc func applyBorder(_ color: UIColor, width: CGFloat) {
    layer.borderWidth = width
    layer.borderColor = color.cgColor
  }
  @objc func applySubscriptionScreenShadowStyle() {
    layer.cornerRadius = 12.0
    layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 5.0
  }

  @objc func subview(_ tag: Int) -> UIView? {
    var result: UIView?
    for subview in subviews where subview.tag == tag {
      result = subview
      break
    }

    return result
  }

  @objc func addBlurEffectView(style: UIBlurEffect.Style = .extraLight) {
    let blurEffect = UIBlurEffect(style: style)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(blurEffectView)
  }
}

fileprivate extension UIView {
  // MARK: - Constraints

  func addSubviewWithDefaultConstraints(_ subview: UIView, edgeInsets: UIEdgeInsets = .zero) {
    subview.frame = bounds
    addSubview(subview)

    let contentView = subview
    contentView.translatesAutoresizingMaskIntoConstraints = false
    let bindings = ["contentView": contentView]
    let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat:
      "|-\(edgeInsets.left)-[contentView]-\(edgeInsets.right)-|",
      options: .alignmentMask, metrics: nil, views: bindings)
    addConstraints(horizontalConstraints)
    let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat:
      "V:|-\(edgeInsets.top)-[contentView]-\(edgeInsets.bottom)-|",
      options: .alignmentMask, metrics: nil, views: bindings)
    addConstraints(verticalConstraints)
  }

  func addSubviewWithCenterConstraints(_ subview: UIView) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false

    //width & height
    let heightConstraint = NSLayoutConstraint(item: subview,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0, constant: subview.bounds.height)
    let widthConstraint = NSLayoutConstraint(item: subview,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0, constant: subview.bounds.width)
    subview.addConstraints([heightConstraint, widthConstraint])

    // Vertically & Horizontally center
    let centerXConstraint =  NSLayoutConstraint(item: subview,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .centerX,
                                                multiplier: 1.0, constant: 0)
    let centerYConstraint =  NSLayoutConstraint(item: subview,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .centerY,
                                                multiplier: 1.0, constant: 0)
    addConstraints([centerXConstraint, centerYConstraint])
  }

  func addSubviewWithTopConstraints(_ subview: UIView) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false

    //width & height
    let heightConstraint = NSLayoutConstraint(item: subview,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0, constant: subview.bounds.height)
    let widthConstraint = NSLayoutConstraint(item: subview,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0, constant: subview.bounds.width)
    subview.addConstraints([heightConstraint, widthConstraint])

    // Vertically & Horizontally center
    let centerXConstraint =  NSLayoutConstraint(item: subview,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .centerX,
                                                multiplier: 1.0, constant: 0)
    let centerYConstraint =  NSLayoutConstraint(item: subview,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .centerY,
                                                multiplier: 1.0, constant: 0)
    addConstraints([centerXConstraint, centerYConstraint])
  }
}

extension NSLayoutConstraint {
  func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: self.firstItem as Any, attribute: self.firstAttribute, relatedBy: self.relation,
            toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
  }
}
  extension UIView {
    func cropAsCircleWithBorder(borderColor: UIColor, strokeWidth: CGFloat) {
      var radius = min(self.bounds.width, self.bounds.height)
      var drawingRect: CGRect = self.bounds
      drawingRect.size.width = radius
      drawingRect.origin.x = (self.bounds.size.width - radius) / 2
      drawingRect.size.height = radius
      drawingRect.origin.y = (self.bounds.size.height - radius) / 2
      radius /= 2
      var path = UIBezierPath(roundedRect: drawingRect.insetBy(dx: strokeWidth/2, dy: strokeWidth/2), cornerRadius: radius)
      let border = CAShapeLayer()
      border.fillColor = UIColor.clear.cgColor
      border.path = path.cgPath
      border.strokeColor = borderColor.cgColor
      border.lineWidth = strokeWidth
      self.layer.addSublayer(border)
      path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      self.layer.mask = mask
    }
}
extension UIView {
  var visibleRect: CGRect? {
    guard let superview = superview else { return nil }
    return frame.intersection(superview.bounds)
  }
}
