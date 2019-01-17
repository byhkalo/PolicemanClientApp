//
//  UITableView+CellViewDataModel.swift
//
//

import UIKit.UITableView

extension UITableView {
  func dequeueReusableCell(for indexPath: IndexPath, with model: AnyViewDataModelType) -> UITableViewCell {
    let cellIdentifier = String(describing: type(of: model).viewClass())
    let cell = dequeueReusableCell(withIdentifier: cellIdentifier,
                                   for: indexPath)
    if var actionCell = cell as? AnyActionView { actionCell.actionsDelegate = self }
    cell.selectionStyle = .none
    model.updateAppearance(of: cell, in: self, at: indexPath)
    model.setup(on: cell)
    return cell
  }
  func dequeueReusableHeaderFooterView(with model: AnyViewDataModelType) -> UITableViewHeaderFooterView {
    let headerIdentifier = String(describing: type(of: model).viewClass())
    let header = dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)!
    model.setup(on: header)
    if var actionHeader = header as? AnyActionView { actionHeader.actionsDelegate = self }
    return header
  }
}
