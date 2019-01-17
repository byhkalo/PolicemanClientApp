//
//  UICollectionView+Registration.swift
//
//

import UIKit

extension UICollectionView {
  enum SupplementaryType {
    case header
    case footer
    var kind: String {
      switch self {
      case .header:
        return UICollectionView.elementKindSectionHeader
      case .footer:
        return UICollectionView.elementKindSectionFooter
      }
    }
  }
  func registerNibs(from displayCollection: DisplayDataCollection) {
    registerNibs(fromType: type(of: displayCollection))
  }
  func registerNibs(fromType displayCollectionType: DisplayDataCollection.Type) {
    for cellModel in displayCollectionType.modelsForRegistration {
      if let tableViewClass = cellModel.viewClass() as? UICollectionViewCell.Type {
        registerNib(for: tableViewClass)
      }
    }
  }
  @objc func registerNib(for viewClass: UICollectionViewCell.Type) {
    register(viewClass.nib, forCellWithReuseIdentifier: viewClass.identifier)
  }
  func registerSupplementaryView(for headerClass: UICollectionReusableView.Type, as type: SupplementaryType) {
    register(headerClass.nib, forSupplementaryViewOfKind: type.kind, withReuseIdentifier: headerClass.identifier)
  }
  @objc func registerClass(for viewClass: UICollectionViewCell.Type) {
    register(viewClass, forCellWithReuseIdentifier: viewClass.identifier)
  }
}
