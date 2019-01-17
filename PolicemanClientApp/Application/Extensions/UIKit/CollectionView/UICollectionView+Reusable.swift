//
//  UICollectionView+Reusable.swift
//
//

import UIKit

extension UICollectionView {
  func dequeue<CellType: Reusable>(reusableCell: CellType.Type, for indexPath: IndexPath) -> CellType {
    let identifier = CellType.identifier
    // swiftlint:disable:next force_cast
    return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CellType
  }
  func dequeue<T: UICollectionReusableView>(reusableSupplementaryViewOf type: SupplementaryType, for
    indexPath: IndexPath) -> T {
    let identifier = T.identifier
    return dequeueReusableSupplementaryView(ofKind: type.kind,
                                            withReuseIdentifier: identifier,
                                            for: indexPath) as! T // swiftlint:disable:this force_cast
  }
}
