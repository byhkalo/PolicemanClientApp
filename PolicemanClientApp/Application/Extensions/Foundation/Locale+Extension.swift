//
//  Locale+Extension.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 8/17/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation

extension Locale {
  static var preferredLanguage: String? {
    let dividedLang = Locale.preferredLanguages.first?.components(separatedBy: "-")
    guard let preferredLanguageCode = dividedLang?.first else { return nil }
    return preferredLanguageCode
  }
}
