//
//  UITableView+Actions.swift
//
//

import UIKit
import ObjectiveC

private var associationKey = "private_TableViewActionsDelegate"

protocol TableViewActionsDelegate: class {
  func tableView(_ tableView: UITableView, didAction action: AnyUserAction, onHeaderIn section: Int)
  func tableView(_ tableView: UITableView, didAction action: AnyUserAction, onCellAt indexPath: IndexPath)
}

extension TableViewActionsDelegate {
  func tableView(_ tableView: UITableView, didAction action: AnyUserAction, onCellAt indexPath: IndexPath) {}
  func tableView(_ tableView: UITableView, didAction action: AnyUserAction, onHeaderIn section: Int) {}
}

extension UITableView {
  weak var cellActionsDelegate: TableViewActionsDelegate? {
    get {
      if let result = objc_getAssociatedObject(self, &associationKey) as? TableViewActionsDelegate {
        return result
      }
      return nil
    }
    set {
      objc_setAssociatedObject(self, &associationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
    }
  }
}

extension UITableView: AnyActionViewDelegate {
  func actionView(_ view: AnyActionView, didAction action: AnyUserAction) {
    if let cell = view as? UITableViewCell {
      guard let indexPath = indexPath(for: cell) else { return }
      cellActionsDelegate?.tableView(self, didAction: action, onCellAt: indexPath)
    } else if let header = view as? UITableViewHeaderFooterView {
      let sectionCount = numberOfSections
      var sectionIndex = 0
      for index in 0..<sectionCount {
        if header == headerView(forSection: index) {
          sectionIndex = index
          break
        }
      }
      cellActionsDelegate?.tableView(self, didAction: action, onHeaderIn: sectionIndex)
    }
  }
}
