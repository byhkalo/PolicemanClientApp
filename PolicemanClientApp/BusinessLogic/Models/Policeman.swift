//
//  Policeman.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/13/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

typealias CompletionHandlerPoliceman = (Policeman) -> Void

struct Policeman: AnyDatabaseModel, Codable {
  let identifier: String
  let id: String
  let isAdmin: Bool
  var isActive: Bool
  let isPoliceman: Bool
  var latitude: Float
  var longitude: Float
  let userFirstName: String
  let userLastName: String
}
