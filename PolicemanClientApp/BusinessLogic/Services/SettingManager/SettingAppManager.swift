//
//  SettingAppManager.swift
//  
//
//  Created by Konstantyn Byhkalo on 3/3/17.
//  Copyright © 2017 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation

// MARK: - Enums
enum Language: String {
  ///Languages List
  case english = "en"
  case polish = "pl"
  case russian = "ru"
  case ukrainian = "uk"
  ///Properties
  static var languagesList: [Language] {
    return [.english, .polish, .russian, .ukrainian]
  }
  var languageCode: String {
    return self.rawValue
  }
  var languageTitle: String {
    switch self {
    case .english: return "English"
    case .polish: return "Polski"
    case .russian: return "Русский"
    case .ukrainian: return "Українська"
    }
  }
  var pretyPrint: String {
    return Locale.canonicalLanguageIdentifier(from: self.rawValue)
  }
}
enum Settings: String {
  case autoplay
  case beaconMode
  case accesToRequest
  case applicationLanguage
  case contentLanguage
  case firstStart
}
// MARK: - AnySettingService
protocol AnySettingService {
  /// Properties
  var beaconMode: Bool { get }
  var autoplayMode: Bool { get }
  var accessToRequest: Bool { get }
  var applicationLanguage: String { get }
  var contentLanguage: String { get }
//  var applicationLanguages
  /// Change
  func autoplayModeChange(to value: Bool)
  func beaconModeChange(to value: Bool)
  func accessToRequestChange(to value: Bool)
  func applicationLanguageChange(to value: String)
  func contentLanguageChange(to value: String)
  /// Handler
  func addHandler(_ completion: @escaping CompletionChangeHandler<Settings>) -> Int
  func removeHandler(handlerId: Int)
}
// MARK: - SettingAppManager
class SettingAppManager {
  // MARK: - Static Propeties
  static let shared = SettingAppManager()
  // MARK: - Propeties
  fileprivate var observingHandlers: [Int: CompletionChangeHandler<Settings>] = [:]
  fileprivate let defaults = UserDefaults.init()
  // MARK: - Init
  private init() {}
  // MARK: - Get Method
  func settingsFor(key: Settings) -> Bool {
    if isFirstStartApp() {
      autoplayModeChange(to: true)
      beaconModeChange(to: true)
      accessToRequestChange(to: true)
      if let preferredLanguageCode = Locale.preferredLanguage,
        let language = Language(rawValue: preferredLanguageCode) {
        applicationLanguageChange(to: language.languageCode)
      } else {
        applicationLanguageChange(to: Language.english.languageCode)
      }
      contentLanguageChange(to: "")
    }
    let value = defaults.bool(forKey: key.rawValue)
    return value
  }
  func settingsFor(key: Settings) -> String {
    if isFirstStartApp() {
      autoplayModeChange(to: true)
      beaconModeChange(to: true)
      accessToRequestChange(to: true)
      if let preferredLanguageCode = Locale.preferredLanguage,
        let language = Language(rawValue: preferredLanguageCode) {
        applicationLanguageChange(to: language.languageCode)
      } else {
        applicationLanguageChange(to: Language.english.languageCode)
      }
      contentLanguageChange(to: "")
    }
    let value = defaults.string(forKey: key.rawValue) ?? ""
    return value
  }
  // MARK: - first startConfiguration
  private func isFirstStartApp() -> Bool {
    let value = defaults.bool(forKey: Settings.firstStart.rawValue)
    if !value {
      defaults.set(!value, forKey: Settings.firstStart.rawValue)
    }
    return !value
  }
}
// MARK: - Observing Handlers
extension SettingAppManager {
  /// MARK: - Handlers
  func addHandler(_ completion: @escaping CompletionChangeHandler<Settings>) -> Int {
    var maxId = observingHandlers.keys.max() ?? 0
    maxId += 1
    observingHandlers[maxId] = completion
    return maxId
  }
  func removeHandler(handlerId: Int) {
    observingHandlers.removeValue(forKey: handlerId)
  }
  private func notifyObservers(about change: Settings) {
    DispatchQueue.global().async {
      self.observingHandlers.forEach { (handler) in
        handler.value(change)
      }
    }
  }
}
// MARK: - AnySettingService
extension SettingAppManager: AnySettingService {
  /// Properties
  var beaconMode: Bool { return settingsFor(key: .beaconMode) }
  var autoplayMode: Bool { return settingsFor(key: .autoplay) }
  var accessToRequest: Bool { return settingsFor(key: .accesToRequest) }
  var applicationLanguage: String { return settingsFor(key: .applicationLanguage) }
  var contentLanguage: String { return settingsFor(key: .contentLanguage) }
  /// Change
  func autoplayModeChange(to value: Bool) {
    defaults.set(value, forKey: Settings.autoplay.rawValue)
    notifyObservers(about: Settings.autoplay)
  }
  func beaconModeChange(to value: Bool) {
    defaults.set(value, forKey: Settings.beaconMode.rawValue)
    notifyObservers(about: Settings.beaconMode)
  }
  func accessToRequestChange(to value: Bool) {
    defaults.set(value, forKey: Settings.accesToRequest.rawValue)
    notifyObservers(about: Settings.accesToRequest)
  }
  func applicationLanguageChange(to value: String) {
    defaults.set(value, forKey: Settings.applicationLanguage.rawValue)
    notifyObservers(about: Settings.applicationLanguage)
  }
  func contentLanguageChange(to value: String) {
    defaults.set(value, forKey: Settings.contentLanguage.rawValue)
    notifyObservers(about: Settings.contentLanguage)
  }
}
