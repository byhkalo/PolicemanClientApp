//
//  EmergencyTableItemDataModel.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/15/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

struct EmergencyTableItemDataModel {
  let identifier: String
  let latitude: String
  let longitude: String
  let requestPerson: String
  let timestamp: Float
}

extension EmergencyTableItemDataModel: ViewDataModelType {
  func setup(on cell: EmergencyTableCell) {
    cell.identifierLabel.text = identifier
    cell.latitudeLabel.text = latitude
    cell.longitudeLabel.text = longitude
    cell.requestPersonLabel.text = requestPerson
    let time = Date(timeIntervalSince1970: Double(timestamp)).description
    cell.requestTimeLabel.text = time
  }
}
