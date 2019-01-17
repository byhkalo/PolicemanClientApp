//
//  Database+Protocols.swift
//
//

import UIKit

import FirebaseDatabase
import FirebaseAuth

protocol AnyDatabaseModelObject {
  associatedtype Model
  var dataModel: Model? { get }
}

// MARK: - Models

/// Protocol to conform any JSON object on Firebase
/**
 1. Apply protocol in Database+Mapping.swift
 2. Apply extensions for id-keys to create query objects and lists in ModelName.swift
 */
protocol AnyDatabaseModel: Codable {
  var identifier: String { get }
  func toDatabaseJSON() -> [AnyHashable : Any]?
  static func collectionRef(_ perentModel: AnyDatabaseModel?) -> String
}
extension AnyDatabaseModel {
  fileprivate static func baseRef() -> String {
    return "\(String(describing: self))/"
  }
  func toDatabaseJSON() -> [AnyHashable : Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
    let unwrapedJsonObject = jsonObject as? [AnyHashable : Any]
    return unwrapedJsonObject
  }
}

extension AnyDatabaseModel where Self == Emergency {
  static func collectionRef(_ perentModel: AnyDatabaseModel?) -> String {
    return baseRef() + "collection/"
  }
}

extension AnyDatabaseModel where Self == Policeman {
  static func collectionRef(_ perentModel: AnyDatabaseModel?) -> String {
    return baseRef() + "collection/"
  }
}

extension AnyDatabaseModel where Self: LocalisedModel {
  static func collectionRef(_ perentModel: AnyDatabaseModel?) -> String {
    return baseRef()
  }
}

typealias DatabaseChange = DataEventType
typealias DatabaseChangeBlock = (DatabaseChange) -> (Swift.Void)

// MARK: - Helpers

protocol AnyDatabseChange: Equatable {}
protocol AnyDatabaseObservable: class {
  associatedtype Change: AnyDatabseChange
  var observingHandlers: [Int: CompletionChangeHandler<Change>] { get set }
  func addHandler(_ completion: @escaping CompletionChangeHandler<Change>) -> Int
  func removeHandler(_ handlerId: Int)
}

extension AnyDatabaseObservable {
  // MARK: - Public
  func addHandler(_ completion: @escaping CompletionChangeHandler<Change>) -> Int {
    var maxId = observingHandlers.keys.max() ?? 0
    maxId += 1
    observingHandlers[maxId] = completion
    return maxId
  }
  func addHandler(for change: Change, _ completion: @escaping CompletionHandler) -> Int {
    return addHandler({ (currentChange) in
      if currentChange == change {
        completion()
      }
    })
  }
  func removeHandler(_ handlerId: Int) {
    observingHandlers.removeValue(forKey: handlerId)
  }
  // MARK: - Protected
  func notifyHandlers(about change: Change) {
    DispatchQueue.global().async {
      self.observingHandlers.forEach { (handler) in
        handler.value(change)
      }
    }
  }
}
protocol AnyNestedObject {
  static func localizableText() -> [String]
  static func localizableContent() -> [String]
}
