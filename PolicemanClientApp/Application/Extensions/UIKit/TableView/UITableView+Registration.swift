//
//  UITableView+Registration.swift
//
//

import UIKit.UITableView

extension UITableView {
  func registerNibs(from displayCollection: DisplayDataCollection) {
    registerNibs(fromType: type(of: displayCollection))
  }
}

fileprivate extension UITableView {
  func registerNibs(fromType displayCollectionType: DisplayDataCollection.Type) {
    for cellModel in displayCollectionType.modelsForRegistration {
      if let tableViewClass = cellModel.viewClass() as? UITableViewCell.Type {
        registerNib(for: tableViewClass)
      } else if let headerFooterClass = cellModel.viewClass() as? UITableViewHeaderFooterView.Type {
        registerHeaderNib(for: headerFooterClass)
      }
    }
  }
  func registerNib(for viewClass: UITableViewCell.Type) {
    register(viewClass.nib, forCellReuseIdentifier: viewClass.identifier)
  }
  func registerHeaderNib(for headerClass: UITableViewHeaderFooterView.Type) {
    register(headerClass.nib, forHeaderFooterViewReuseIdentifier: headerClass.identifier)
  }
  func registerClass(for viewClass: UITableViewCell.Type) {
    register(viewClass, forCellReuseIdentifier: viewClass.identifier)
  }
}
