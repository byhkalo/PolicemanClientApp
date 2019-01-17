//
//  LocalizeStringService.swift
//
//

import Foundation

protocol AnyLocalizeService: class {
  // MARK: - Properties
  associatedtype LocalizeType: LocalisedModel
  static var localizedObjects: [String: DatabaseObject<LocalizeType>] { get set }
  static var localizeHandlerIds: [String: Int] { get set }
  static var cache: [String: String] { get set }
  // Functions
  static func localize(_ id: String, completion: @escaping (String) -> Void)
}

extension AnyLocalizeService {
  // MARK: - Fetch object localization
  internal static func localize(_ id: String, completion: @escaping (String) -> Void) {
    let cacheId = SettingAppManager.shared.contentLanguage + "_" + id
    if let localizedText = cache[cacheId] {
      completion(localizedText)
      return
    }
    //    if localizedObjects[id] != nil { return }
    let object = DatabaseObject<LocalizeType>(localizedStringId: id)
    localizedObjects[id] = object
    let handlerId = object.addHandler { (_) in
      guard let text = object.dataModel?.value
        else { return }
      if !text.isEmpty {
        cache[cacheId] = text
      }
      localizedObjects.removeValue(forKey: id)
      completion(text)
      guard let handler = localizeHandlerIds[id] else { return }
      object.removeHandler(handler)
      localizeHandlerIds.removeValue(forKey: id)
    }
    localizeHandlerIds[id] = handlerId
  }
}

class LocalizeStringService: AnyLocalizeService {
  // MARK: - Properties
  typealias LocalizeType = LocalisedString
  static var localizedObjects: [String: DatabaseObject<LocalisedString>] = [:]
  static var localizeHandlerIds: [String: Int] = [:]
  static var cache: [String: String] = [:]
}
