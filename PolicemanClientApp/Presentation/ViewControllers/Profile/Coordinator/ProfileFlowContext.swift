//
//  ProfileFlowContext.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

enum ProfileFlowChange: AnyContextChange {
  /// Cases
  case none
  /// Init
  init() { self = .none }
}

protocol AnyProfileFlowContext {
  var policamanObject: DatabaseObject<Policeman> { get }
}

typealias AnyProfileObservableFlowContext = (ObservableContext<ProfileFlowChange> & AnyProfileFlowContext)

class ProfileFlowContext: ObservableContext<ProfileFlowChange> {
  // Paste Storage Properties
  // MARK: - Properties
  fileprivate(set) var policamanObject: DatabaseObject<Policeman>
  // MARK: - Private Properties
  init(policemanObject: DatabaseObject<Policeman>) {
    self.policamanObject = policemanObject
  }
}

extension ProfileFlowContext: AnyProfileFlowContext {
  
}
