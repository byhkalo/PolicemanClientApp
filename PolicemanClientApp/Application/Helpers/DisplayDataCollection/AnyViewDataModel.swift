//
//  AnyViewDataModel.swift
//
//

import UIKit

// Use this type in non-generic cases
protocol AnyViewDataModelType {
  static func viewClass() -> UIView.Type
  func setup(on view: UIView)
  func updateAppearance(of view: UIView, in parentView: UIView, at indexPath: IndexPath)
}

extension AnyViewDataModelType {
  func updateAppearance(of view: UIView, in parentView: UIView, at indexPath: IndexPath) { }
}

// This is for generic one and models itselfs
protocol ViewDataModelType: AnyViewDataModelType {
  associatedtype ViewClass: UIView
  func setup(on view: ViewClass)
}

// From generic to runtime
extension ViewDataModelType {
  static func viewClass() -> UIView.Type {
    return Self.ViewClass.self
  }
  func setup(on view: UIView) {
    setup(on: view as! Self.ViewClass) // swiftlint:disable:this force_cast
  }
}

// Use it for future purposes
struct EmptyDataModel: ViewDataModelType {}
