//
//  AnyActionView.swift
//
//

import UIKit

/// Use this protocol for any actions on cells
/// You should create nested 'enum Action: AnyUserAction' inside you view
/// to efficiently use the solution
protocol AnyUserAction {}

// MARK: - Action handler
/// Use it for cell and header views internal actions,
/// Apply the protocol for the cell or view
protocol AnyActionView {
  var actionsDelegate: AnyActionViewDelegate? { get set }
}

// MARK: - Cell Actions Delegate

protocol AnyActionViewDelegate: class {
  func actionView(_ view: AnyActionView, didAction action: AnyUserAction)
}
