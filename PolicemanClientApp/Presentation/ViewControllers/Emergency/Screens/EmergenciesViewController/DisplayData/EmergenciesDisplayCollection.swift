//
//  EmergenciesDisplayCollection.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/15/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit

class EmergenciesDisplayCollection: DisplayDataCollection {
  // MARK: - Static Properties
  static var modelsForRegistration: [AnyViewDataModelType.Type] {
    return [EmergencyTableItemDataModel.self]
  }
  // MARK: - Private Properties
  fileprivate let viewModel: AnyEmergenciesCollectionViewModel
  // MARK: - Init
  init(_ viewModel: AnyEmergenciesCollectionViewModel) {
    self.viewModel = viewModel
  }
  // MARK: - DataSource
  func numberOfRows(in section: Int) -> Int {
    return viewModel.numberOfEmergencies()
  }
  func model(for indexPath: IndexPath) -> AnyViewDataModelType {
    guard let emergency = viewModel.emergency(indexPath: indexPath)
      else { return EmptyDataModel() }
    let dataItem = EmergencyTableItemDataModel(
      identifier: emergency.id,
      latitude: "\(emergency.latitude)",
      longitude: "\(emergency.longitude)",
      requestPerson: emergency.requestPerson,
      timestamp: emergency.timestamp)
    return dataItem
  }
  func heightForRow(at indexPath: IndexPath) -> CGFloat {
    return 175.0
  }
}

// MARK: - ViewDataModelType
extension EmergenciesDisplayCollection: ViewDataModelType {
  func setup(on tableView: UITableView) {
    tableView.registerNibs(from: self)
  }
}
