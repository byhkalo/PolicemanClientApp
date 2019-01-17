//
//  UICollectionView+Actions.swift
//
//

import UIKit
import ObjectiveC

private var associationKey = "private_CollectionViewActionsDelegate"

protocol CollectionViewActionsDelegate: class {
  func collectionView(_ collectionView: UICollectionView,
                      didAction action: AnyUserAction,
                      onCellAt indexPath: IndexPath)
}

extension UICollectionView {
  weak var cellActionsDelegate: CollectionViewActionsDelegate? {
    get {
      if let result = objc_getAssociatedObject(self, &associationKey) as? CollectionViewActionsDelegate {
        return result
      }
      return nil
    }
    set {
      objc_setAssociatedObject(self, &associationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
    }
  }
}

extension UICollectionView: AnyActionViewDelegate {
  func actionView(_ view: AnyActionView, didAction action: AnyUserAction) {
    if let cell = view as? UICollectionViewCell {
      guard let indexPath = indexPath(for: cell) else { return }
      cellActionsDelegate?.collectionView(self, didAction: action, onCellAt: indexPath)
    }
  }
}
