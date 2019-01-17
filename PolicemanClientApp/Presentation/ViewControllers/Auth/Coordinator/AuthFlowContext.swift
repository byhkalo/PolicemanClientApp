//
//  AuthFlowContext.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/13/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

enum AuthFlowChange: AnyContextChange {
  /// Cases
  case none
  /// Init
  init() { self = .none }
}

protocol AnyAuthFlowContext {
  // It's MuseumFlowContext Interfase
  var mainContext: AnyMainObservableFlowContext? { get }
  var authService: AnyAuthService { get }
  var policemanObject: DatabaseObject<Policeman>? { get set }
}

typealias AnyAuthObservableFlowContext = (ObservableContext<AuthFlowChange> & AnyAuthFlowContext)

class AuthFlowContext: ObservableContext<AuthFlowChange> {
  // Paste Storage Properties
  var policemanObject: DatabaseObject<Policeman>? = nil
  var authService: AnyAuthService = AuthService.shared
  lazy fileprivate(set) var mainContext: AnyMainObservableFlowContext? = {
    guard let policemanObject = policemanObject else { return nil }
    return MainFlowContext(policemanObject: policemanObject)
  }()
  
  // MARK: - Init
  init(authService: AnyAuthService) {
    self.authService = authService
  }
}

extension AuthFlowContext: AnyAuthFlowContext {
  // Implement AnyAuthFlowContext methods
}
