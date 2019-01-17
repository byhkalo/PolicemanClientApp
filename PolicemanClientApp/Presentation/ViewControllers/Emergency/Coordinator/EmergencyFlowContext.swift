//
//  EmergencyFlowContext.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

enum EmergencyFlowChange: AnyContextChange {
  /// Cases
  case none
  /// Init
  init() { self = .none }
}

protocol AnyEmergencyFlowContext {
  var policemanObject: DatabaseObject<Policeman> { get }
  var emergenciesCollection: DatabaseCollection<Emergency> { get }
  var selectedEmergency: DatabaseObject<Emergency>? { get  set }
}

typealias AnyEmergencyObservableFlowContext = (ObservableContext<EmergencyFlowChange> & AnyEmergencyFlowContext)

class EmergencyFlowContext: ObservableContext<EmergencyFlowChange> {
  // Paste Storage Properties
  // MARK: - Properties
  var selectedEmergency: DatabaseObject<Emergency>?
  // MARK: - Private Properties
  fileprivate(set) var policemanObject: DatabaseObject<Policeman>
  fileprivate(set) var emergenciesCollection: DatabaseCollection<Emergency>
  // MARK: - Init
  init(policemanObject: DatabaseObject<Policeman>,
       emergenciesCollection: DatabaseCollection<Emergency>) {
    self.policemanObject = policemanObject
    self.emergenciesCollection = emergenciesCollection
  }
}
// MARK: - Extension AnyEmergencyFlowContext
extension EmergencyFlowContext: AnyEmergencyFlowContext {}
