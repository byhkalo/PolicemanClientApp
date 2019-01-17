//
//  ProfilePolicemanViewModel.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

enum ProfilePolicemanChange {
  case node
  case policemanUpdated
  case activityChanged
}

typealias ProfilePolicemanUpdateHandler = CompletionChangeHandler<ProfilePolicemanChange>

protocol AnyProfilePolicemanViewModel: class {
  /// Properties
  var profilePolicemanUpdateHandler: ProfilePolicemanUpdateHandler? { get set }
  var navigationTitle: String { get }
  var policemanName: String { get }
  var identifier: String { get }
  var isAdmin: Bool { get }
  var latitude: String { get }
  var longitude: String { get }
  var isActive: Bool { get }
  var latitudeFloat: Float { get }
  var longitudeFloat: Float { get }
  /// Actions
  func activeStateChanged(to value: Bool)
  func backAction()
}

class ProfilePolicemanViewModel {
  // MARK: - Properties
  var navigationTitle: String { return "Profile" }
  var policemanName: String {
    guard let policemanModel = policemanObject.dataModel else { return "" }
    return "\(policemanModel.userFirstName) \(policemanModel.userLastName)"
  }
  var identifier: String {
    guard let policemanModel = policemanObject.dataModel else { return "" }
    return policemanModel.identifier
  }
  var isAdmin: Bool {
    guard let policemanModel = policemanObject.dataModel else { return false }
    return policemanModel.isAdmin
  }
  var latitude: String {
    guard let policemanModel = policemanObject.dataModel else { return "" }
    return "\(policemanModel.latitude)"
  }
  var longitude: String {
    guard let policemanModel = policemanObject.dataModel else { return "" }
    return "\(policemanModel.longitude)"
  }
  var latitudeFloat: Float {
    guard let policemanModel = policemanObject.dataModel else { return 0.0 }
    return policemanModel.latitude
  }
  var longitudeFloat: Float {
    guard let policemanModel = policemanObject.dataModel else { return 0.0 }
    return policemanModel.longitude
  }
  var isActive: Bool {
    guard let policemanModel = policemanObject.dataModel else { return false }
    return policemanModel.isActive
  }
  /// Handler
  var profilePolicemanUpdateHandler: ProfilePolicemanUpdateHandler?
  // MARK: - Private Properties
  fileprivate var policemanHandlerId: Int = 0
  fileprivate let policemanObject: DatabaseObject<Policeman>
  fileprivate let managedPolicemanObject: ManageDatabaseObject<Policeman>
  fileprivate(set) var context: AnyProfileObservableFlowContext
  fileprivate(set) weak var router: AnyProfileRouter?
  // MARK: - Init
  init(context: AnyProfileObservableFlowContext, router: AnyProfileRouter,
       policemanObject: DatabaseObject<Policeman>) {
    self.context = context
    self.router = router
    self.policemanObject = policemanObject
    self.managedPolicemanObject = ManageDatabaseObject(databaseObject: policemanObject)
    subscribeHandlers()
  }
  deinit {
    unsubscribeHandlers()
  }
  
}
// MARK: - Private Handlers
private extension ProfilePolicemanViewModel {
  func subscribeHandlers() {
    policemanHandlerId = policemanObject.addHandler({ [weak self] (change) in
      guard let `self` = self else { return }
      guard let profilePolicemanUpdateHandler =
        self.profilePolicemanUpdateHandler else { return }
      profilePolicemanUpdateHandler(.policemanUpdated)
    })
  }
  func unsubscribeHandlers() {
    context.policamanObject.removeHandler(policemanHandlerId)
  }
}
// MARK: - Extension AnyProfilePolicemanViewModel
extension ProfilePolicemanViewModel: AnyProfilePolicemanViewModel {
  func activeStateChanged(to value: Bool) {
    guard var policeMan = policemanObject.dataModel else { return }
    policeMan.isActive = value
    managedPolicemanObject.updateModel(policeMan)
  }
  func backAction() {
    router?.closeProfileScreen()
  }
}
