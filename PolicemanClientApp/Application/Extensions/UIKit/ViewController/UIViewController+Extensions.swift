//
//  UIViewController+Extensions.swift
//
//

import UIKit

extension UIViewController {

  func addViewController(_ viewController: UIViewController,
                         on holderView: UIView,
                         with constraintsType: UIView.ConstraintsType = .fillToEdge(.zero)) {
    addChild(viewController)
    viewController.view.frame = holderView.bounds
    holderView.addSubview(viewController.view, with: constraintsType)
    viewController.didMove(toParent: self)
  }

  @objc func removeViewController(_ childController: UIViewController) {
    childController.willMove(toParent: nil)
    childController.view.removeFromSuperview()
    childController.removeFromParent()
  }
}

fileprivate extension UIViewController {

  func addViewController(_ viewController: UIViewController, on holderView: UIView) {
    addChild(viewController)
    viewController.view.frame = holderView.bounds
    holderView.addSubview(viewController.view)
    viewController.didMove(toParent: self)
  }
}

extension UIViewController {
  var isModal: Bool {
    if presentingViewController != nil && presentingViewController?.presentedViewController?.isBeingPresented == true {
      return true
    }
    if let presentingVC = tabBarController?.presentingViewController, presentingVC is UITabBarController {
      return true
    }
    return false
  }
}
