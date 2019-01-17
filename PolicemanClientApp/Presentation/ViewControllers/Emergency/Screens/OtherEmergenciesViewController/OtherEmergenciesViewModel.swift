//
//  OtherEmergenciesViewModel.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

enum OtherEmergenciesChange {
  case node
  case policemanUpdated
  case activityChanged
}

typealias OtherEmergenciesUpdateHandler = CompletionChangeHandler<OtherEmergenciesChange>

class OtherEmergenciesViewModel {
  // MARK: - Properties
  /// Handler
  var emergenciesUpdateHandler: EmergenciesUpdateHandler?
  var navigationTitle: String { return "Other Emergencies" }
  // MARK: - Private Properties
  fileprivate var policemanHandlerId: Int = 0
  fileprivate var emergenciesHandlerId: Int = 0
  fileprivate let policemanObject: DatabaseObject<Policeman>
  fileprivate let emergenciesCollection: DatabaseCollection<Emergency>
  fileprivate(set) var context: AnyEmergencyObservableFlowContext
  fileprivate(set) weak var router: AnyEmergencyRouter?
  fileprivate var presentingModels: [Emergency] = []
  // MARK: - Init
  init(context: AnyEmergencyObservableFlowContext, router: AnyEmergencyRouter) {
    self.context = context
    self.router = router
    emergenciesCollection = context.emergenciesCollection
    policemanObject = context.policemanObject
    subscribeHandlers()
    recalculateEmergencies()
  }
  deinit {
    unsubscribeHandlers()
  }
  
}
// MARK: - Private Handlers
private extension OtherEmergenciesViewModel {
  func subscribeHandlers() {
    policemanHandlerId = policemanObject.addHandler({ [weak self] (change) in
      guard let `self` = self else { return }
      guard let emergenciesUpdateHandler =
        self.emergenciesUpdateHandler else { return }
      emergenciesUpdateHandler(.policemanUpdated)
      self.recalculateEmergencies()
    })
    emergenciesHandlerId = emergenciesCollection.addHandler({ [weak self] (change) in
      guard let `self` = self else { return }
      switch change {
      case .updated: self.recalculateEmergencies()
      }
    })
  }
  func unsubscribeHandlers() {
    policemanObject.removeHandler(policemanHandlerId)
    emergenciesCollection.removeHandler(emergenciesHandlerId)
  }
}
// MARK: - Private Help Methods
extension OtherEmergenciesViewModel {
  func recalculateEmergencies() {
    presentingModels = []
    guard let policemanId = policemanObject.dataModel?.id
      else { emergenciesUpdateHandler?(.emergenciesUpdated); return }
    presentingModels = emergenciesCollection.compactMap({ (emergencyModel) -> Emergency? in
      guard let tempEmergency = emergencyModel?.dataModel else { return nil }
      let isContain = tempEmergency.containPoliceman(identifier: policemanId)
      return isContain ? nil : tempEmergency
    })
    emergenciesUpdateHandler?(.emergenciesUpdated)
  }
}
// MARK: - Extension AnyMyEmergenciesViewModel
extension OtherEmergenciesViewModel: AnyEmergenciesViewModel {
  func selectEmergency(at indexPath: IndexPath) {
    let emergency = presentingModels[indexPath.row]
    let emergencyObject = emergenciesCollection.first { (tempEmergencyObject) -> Bool in
      guard let tempEmergencyModel = tempEmergencyObject?.dataModel
        else { return false }
      return tempEmergencyModel.id == emergency.id
    }
    guard let unwrap1 = emergencyObject, let tempEmergencyObject = unwrap1 else { return }
    context.selectedEmergency = tempEmergencyObject
    router?.showDetailEmergency()
  }
  func backAction() {
    router?.closeMyEmergenciesScreen()
  }
}
// MARK: - Extension AnyEmergenciesCollectionViewModel
extension OtherEmergenciesViewModel: AnyEmergenciesCollectionViewModel {
  func numberOfEmergencies() -> Int {
    return presentingModels.count
  }
  
  func emergency(indexPath: IndexPath) -> Emergency? {
    let emergency = presentingModels[indexPath.row]
    return emergency
  }
}

