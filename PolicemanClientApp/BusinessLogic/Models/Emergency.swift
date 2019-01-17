//
//  Emergency.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/13/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

typealias CompletionHandlerEmergency = (Emergency) -> Void

struct Emergency: AnyDatabaseModel, Codable {
  // AcceptedPoliceman Model
  struct AcceptedPoliceman: Codable {
    let id: String
    var isAccept: Bool
  }
  // AmdulanceDetail Model
  struct AmdulanceDetail: Codable {
    var isCompleted: Bool
    var isRequested: Bool
  }
  let identifier: String
  let id: String
  let info: String
  let latitude: Float
  let longitude: Float
  let requestPerson: String
  let timestamp: Float
  var ambulanceDetail: AmdulanceDetail
  var acceptedPolicemans: [AcceptedPoliceman]?
}

extension Emergency {
  func containPoliceman(identifier: String) -> Bool {
    guard let acceptedPolicemans = acceptedPolicemans
      else { return false }
    let isContain = acceptedPolicemans.contains { (accPoliceman) -> Bool in
      return accPoliceman.id == identifier
    }
    return isContain
  }
  func acceptInfo(policemanId: String) -> AcceptedPoliceman? {
    guard let acceptedPolicemans = acceptedPolicemans else { return nil }
    return acceptedPolicemans.first(where: { (accPoliceman) -> Bool in
      return accPoliceman.id == policemanId
    })
  }
}
