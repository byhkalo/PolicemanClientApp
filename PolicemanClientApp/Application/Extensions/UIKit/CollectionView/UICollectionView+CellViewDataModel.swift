//
//  UICollectionView+CellViewDataModel.swift
//
//

import UIKit

extension UICollectionView {
  func dequeueReusableCell(for indexPath: IndexPath, with model: AnyViewDataModelType) -> UICollectionViewCell {
    let cellIdentifier = String(describing: type(of: model).viewClass())
    let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    model.updateAppearance(of: cell, in: self, at: indexPath)
    model.setup(on: cell)
    if var actionCell = cell as? AnyActionView { actionCell.actionsDelegate = self }
    return cell
  }
}
