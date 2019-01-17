//
//  LaunchFlowContext.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 4/30/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation

enum LaunchFlowChange: AnyContextChange {
  /// Cases
  case none
  /// Init
  init() { self = .none }
}

protocol AnyLaunchFlowContext {
  // It's MuseumFlowContext Interfase
  var mainContext: AnyMainObservableFlowContext? { get }
  var authContext: AnyAuthObservableFlowContext { get }
  var authService: AnyAuthService { get }
  var policemanObject: DatabaseObject<Policeman>? { get set }
}

typealias AnyLaunchObservableFlowContext = (ObservableContext<LaunchFlowChange> & AnyLaunchFlowContext)

class LaunchFlowContext: ObservableContext<LaunchFlowChange> {
  // Paste Storage Properties
  var policemanObject: DatabaseObject<Policeman>? = nil
  var authService: AnyAuthService = AuthService.shared
  lazy fileprivate(set) var mainContext: AnyMainObservableFlowContext? = {
    guard let policemanObject = policemanObject else { return nil }
    return MainFlowContext(policemanObject: policemanObject)
  }()
  lazy fileprivate(set) var authContext: AnyAuthObservableFlowContext = AuthFlowContext(authService: authService)
}

extension LaunchFlowContext: AnyLaunchFlowContext {
  // Implement AnyMuseumFlowContext methods
}
