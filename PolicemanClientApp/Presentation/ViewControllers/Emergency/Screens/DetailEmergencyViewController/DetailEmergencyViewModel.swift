//
//  DetailEmergencyViewModel.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import MapKit

enum DetailEmergencyChange {
  case node
  case policemanUpdated
  case emergencyUpdated
}

typealias DetailEmergencyUpdateHandler = CompletionChangeHandler<DetailEmergencyChange>

protocol AnyDetailEmergencyViewModel: class {
  /// Properties
  var detailEmergencyUpdateHandler: DetailEmergencyUpdateHandler? { get set }
  var navigationTitle: String { get }
  var identifier: String { get }
  var location: String { get }
  var requestPerson: String { get }
  var requestTime: String { get }
  var infoText: String { get }
  var latitude: Float { get }
  var longitude: Float { get }
  var isActivatedEmergency: Bool { get }
  var isRequestAmbulance: Bool { get }
  var isAcceptedEmergency: Bool { get }
  /// Actions
  func navigateToAction()
  func acceptEmergencyAction()
  func activateEmergencyAction()
  func requestAmbulanceAction()
  func backAction()
}

class DetailEmergencyViewModel {
  // MARK: - Properties
  var identifier: String {
    guard let emergencyModel = emergency.dataModel else { return "" }
    return emergencyModel.identifier
  }
  var location: String {
    guard let emergencyModel = emergency.dataModel else { return "" }
    return "LAT:\(emergencyModel.latitude) | LONG:\(emergencyModel.longitude)"
  }
  var requestPerson: String {
    guard let emergencyModel = emergency.dataModel else { return "" }
    return emergencyModel.requestPerson
  }
  var requestTime: String {
    guard let emergencyModel = emergency.dataModel else { return "" }
    let date = Date(timeIntervalSince1970: TimeInterval(emergencyModel.timestamp))
    return date.description
  }
  var infoText: String {
    guard let emergencyModel = emergency.dataModel else { return "" }
    return emergencyModel.info
  }
  var latitude: Float {
    guard let emergencyModel = emergency.dataModel else { return 0.0 }
    return emergencyModel.latitude
  }
  var longitude: Float {
    guard let emergencyModel = emergency.dataModel else { return 0.0 }
    return emergencyModel.longitude
  }
  var isRequestAmbulance: Bool {
    guard let emergencyModel = emergency.dataModel else { return false }
    return emergencyModel.ambulanceDetail.isRequested
  }
  var isActivatedEmergency: Bool {
    guard let emergencyModel = emergency.dataModel,
      let policemanModel = context.policemanObject.dataModel
      else { return false }
    return emergencyModel.containPoliceman(identifier: policemanModel.id)
  }
  var isAcceptedEmergency: Bool {
    guard let emergencyModel = emergency.dataModel,
      let policemanModel = context.policemanObject.dataModel,
      let acceptInfo = emergencyModel.acceptInfo(policemanId: policemanModel.id)
      else { return false }
    return acceptInfo.isAccept
  }
  var navigationTitle: String { return "Detail Emergency" }
  /// Handler
  var detailEmergencyUpdateHandler: DetailEmergencyUpdateHandler?
  // MARK: - Private Properties
  fileprivate var policemanHandlerId: Int = 0
  fileprivate var emergencyHandlerId: Int = 0
  fileprivate let emergency: DatabaseObject<Emergency>
  fileprivate let managedEmergency: ManageDatabaseObject<Emergency>
  fileprivate(set) var context: AnyEmergencyObservableFlowContext
  fileprivate(set) weak var router: AnyEmergencyRouter?
  // MARK: - Init
  init(context: AnyEmergencyObservableFlowContext, router: AnyEmergencyRouter, emergency: DatabaseObject<Emergency>) {
    self.context = context
    self.router = router
    self.emergency = emergency
    self.managedEmergency = ManageDatabaseObject(databaseObject: emergency)
    subscribeHandlers()
  }
  deinit {
    unsubscribeHandlers()
  }
  
}
// MARK: - Private Handlers
private extension DetailEmergencyViewModel {
  func subscribeHandlers() {
    policemanHandlerId = context.policemanObject.addHandler({ [weak self] (change) in
      guard let `self` = self else { return }
      self.detailEmergencyUpdateHandler?(.policemanUpdated)
    })
    emergencyHandlerId = emergency.addHandler({ [weak self] (change) in
      guard let `self` = self else { return }
      self.detailEmergencyUpdateHandler?(.policemanUpdated)
    })
  }
  func unsubscribeHandlers() {
    context.policemanObject.removeHandler(policemanHandlerId)
    emergency.removeHandler(emergencyHandlerId)
  }
}
// MARK: - Extension AnyDetailEmergencyViewModel
extension DetailEmergencyViewModel: AnyDetailEmergencyViewModel {
  func navigateToAction() {
    guard let emergencyModel = emergency.dataModel else { return }
    let latitude = CLLocationDegrees(emergencyModel.latitude)
    let longitude = CLLocationDegrees(emergencyModel.longitude)
    
    let regionDistance: CLLocationDistance = 10000
    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
    let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
    let options = [
      MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
      MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
      MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving
      ] as [String : Any]
    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = "Emergency"
    mapItem.openInMaps(launchOptions: options)
  }
  
  func activateEmergencyAction() {
    guard var emergencyModel = emergency.dataModel,
    let policemanModel = context.policemanObject.dataModel,
      isActivatedEmergency == false else { return }
    var acceptedPolicemans = emergencyModel.acceptedPolicemans ?? []
    let acceptPoliceman = Emergency.AcceptedPoliceman(id: policemanModel.id, isAccept: false)
    acceptedPolicemans.append(acceptPoliceman)
    emergencyModel.acceptedPolicemans = acceptedPolicemans
      managedEmergency.updateModel(emergencyModel)
  }
  func acceptEmergencyAction() {
    guard var emergencyModel = emergency.dataModel,
      let policemanModel = context.policemanObject.dataModel,
      isAcceptedEmergency == false else { return }
    var acceptedPolicemans = emergencyModel.acceptedPolicemans ?? []
    let index = acceptedPolicemans.firstIndex(where: { $0.id == policemanModel.id })
    if let index = index {
      acceptedPolicemans.remove(at: index)
    }
    if var acceptPoliceman = emergencyModel.acceptInfo(policemanId: policemanModel.id) {
      acceptPoliceman.isAccept = true
      acceptedPolicemans.append(acceptPoliceman)
      emergencyModel.acceptedPolicemans = acceptedPolicemans
      managedEmergency.updateModel(emergencyModel)
    }
  }
  func requestAmbulanceAction() {
    guard var emergencyModel = emergency.dataModel,
      isRequestAmbulance == false else { return }
    emergencyModel.ambulanceDetail.isRequested = true
    managedEmergency.updateModel(emergencyModel)
  }
  func backAction() {
    router?.closeMyEmergenciesScreen()
  }
}
