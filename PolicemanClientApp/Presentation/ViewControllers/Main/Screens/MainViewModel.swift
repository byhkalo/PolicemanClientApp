//
//  MainViewModel.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 5/6/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation
import CoreLocation

enum MainChange {
  case none
  case updateGuides
  case updateMuseum
}

typealias MainUpdateHandler = CompletionChangeHandler<MainChange>

protocol AnyMainViewModel: class {
  /// Properties
  var mainUpdateHandler: MainUpdateHandler? { get set }
  var navigationTitle: String { get }
  /// Controller Lifecycle
  /// Actions
  func myEmergenciesAction()
  func otherEmergenciesAction()
  func profileAction()
  func createEmergency()
  func get(latitude: Float, longitude: Float)
}
// MARK: - MainViewModel
class MainViewModel {
  // MARK: - Properties
  var mainUpdateHandler: MainUpdateHandler?
  var navigationTitle: String { return "Menu" }
  // MARK: - Private Properties
  fileprivate(set) var context: AnyMainObservableFlowContext
  fileprivate(set) weak var router: AnyMainRouter?
  // MARK: - Init
  init(context: AnyMainObservableFlowContext, router: AnyMainRouter) {
    self.context = context
    self.router = router
    subcribeHandlers()
  }
  deinit {
    unsubcribeHandlers()
  }
}
// MARK: - Private Handlers
private extension MainViewModel {
  func subcribeHandlers() {
  }
  func unsubcribeHandlers() {
  }
  func notifyUpdate(_ change: MainChange) {
    self.mainUpdateHandler?(change)
  }
}
// MARK: - Extensions
extension MainViewModel: AnyMainViewModel {
  func myEmergenciesAction() {
    router?.presentMyEmergencies()
  }
  func otherEmergenciesAction() {
    router?.presentOtherEmergencies()
  }
  func profileAction() {
    router?.presentProfile()
  }
  func get(latitude: Float, longitude: Float) {
    guard var policemanModel = context.policemanObject.dataModel else { return }
    policemanModel.latitude = latitude
    policemanModel.longitude = longitude
    context.managedPolicemanObject.updateModel(policemanModel)
  }
  func createEmergency() {
    guard let policemanModel = context.policemanObject.dataModel,
      let policemansArray = context.policemanCollection.arrayOfObjects else { return }
    let addedPolicemans = policemansArray.filter { (policeman) -> Bool in
      
      let coordinate1 = CLLocation(latitude: Double(policemanModel.latitude),
                                   longitude: Double(policemanModel.longitude))
      let coordinate2 = CLLocation(latitude: Double(policeman.latitude),
                                   longitude: Double(policeman.longitude))
      let distanceInMeters = coordinate1.distance(from: coordinate2)
      return distanceInMeters <= 5000
    }
    let policemansToAdd = addedPolicemans
      .map { (policeman) -> Emergency.AcceptedPoliceman in
      return Emergency.AcceptedPoliceman(id: policeman.id, isAccept: false)
    }
    let timestamp = Int(Date().timeIntervalSince1970)
    let id = "\(timestamp)+\(policemanModel.id)"
    let ambulanceDetail = Emergency.AmdulanceDetail(isCompleted: false, isRequested: false)
    let newEmergency =
      Emergency(identifier: id,
                id: id,
                info: "Emergency Info",
                latitude: policemanModel.latitude,
                longitude: policemanModel.longitude,
                requestPerson: policemanModel.id,
                timestamp: Float(timestamp),
                ambulanceDetail: ambulanceDetail,
                acceptedPolicemans: policemansToAdd)
    context.managedEmergenciesCollection.addModel(newEmergency)
  }
}
