//
//  Codable+Extension.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 8/8/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
