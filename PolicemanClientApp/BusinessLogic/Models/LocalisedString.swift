//
//  LocalisedString.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

protocol LocalisedModel: AnyDatabaseModel {
  var value: String { get }
}
struct LocalisedString: LocalisedModel {
  var identifier: String
  var value: String
}
