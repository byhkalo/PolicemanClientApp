//
//  EmergenciesViewModel.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

enum EmergenciesChange {
  case node
  case policemanUpdated
  case emergenciesUpdated
}

typealias EmergenciesUpdateHandler = CompletionChangeHandler<EmergenciesChange>

protocol AnyEmergenciesCollectionViewModel {
  func numberOfEmergencies() -> Int
  func emergency(indexPath: IndexPath) -> Emergency?
}

protocol AnyEmergenciesViewModel: class {
  /// Properties
  var navigationTitle: String { get }
  var emergenciesUpdateHandler: EmergenciesUpdateHandler? { get set }
  /// Actions
  func selectEmergency(at indexPath: IndexPath)
  func backAction()
}
