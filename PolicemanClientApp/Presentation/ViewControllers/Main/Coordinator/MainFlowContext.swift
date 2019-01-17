//
//  MainFlowContext.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 5/6/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation

enum MainFlowChange: AnyContextChange {
  /// Cases
  case none
  /// Init
  init() { self = .none }
}

protocol AnyMainFlowContext {
  var policemanObject: DatabaseObject<Policeman> { get }
  var managedPolicemanObject: ManageDatabaseObject<Policeman> { get }
  var policemanCollection: DatabaseCollection<Policeman> { get }
  var emergenciesCollection: DatabaseCollection<Emergency> { get }
  var managedEmergenciesCollection: ManageDatabaseCollection<Emergency> { get }
  var myEmergenciesContext: AnyEmergencyObservableFlowContext { get }
  var otherEmergenciesContext: AnyEmergencyObservableFlowContext { get }
  var profileContext: AnyProfileObservableFlowContext { get }
}

typealias AnyMainObservableFlowContext = (ObservableContext<MainFlowChange> & AnyMainFlowContext)

class MainFlowContext: ObservableContext<MainFlowChange> {
  // MARK: - Properties
  let policemanObject: DatabaseObject<Policeman>
  let managedPolicemanObject: ManageDatabaseObject<Policeman>
  var policemanCollection = DatabaseCollection<Policeman>()
  let emergenciesCollection = DatabaseCollection<Emergency>()
  var managedEmergenciesCollection: ManageDatabaseCollection<Emergency>
  // MARK: - Private Properties
  lazy fileprivate(set) var myEmergenciesContext: AnyEmergencyObservableFlowContext = {
    return EmergencyFlowContext(policemanObject: policemanObject, emergenciesCollection: emergenciesCollection)
  }()
  lazy fileprivate(set) var otherEmergenciesContext: AnyEmergencyObservableFlowContext = {
    return EmergencyFlowContext(policemanObject: policemanObject, emergenciesCollection: emergenciesCollection)
  }()
  lazy fileprivate(set) var profileContext: AnyProfileObservableFlowContext = {
    return ProfileFlowContext(policemanObject: policemanObject)
  }()
  // MARK: Init
  init(policemanObject: DatabaseObject<Policeman>) {
    self.policemanObject = policemanObject
    self.managedPolicemanObject = ManageDatabaseObject(databaseObject: policemanObject)
    self.managedEmergenciesCollection =
      ManageDatabaseCollection(databaseCollection: emergenciesCollection)
  }
}

extension MainFlowContext: AnyMainFlowContext {
}
