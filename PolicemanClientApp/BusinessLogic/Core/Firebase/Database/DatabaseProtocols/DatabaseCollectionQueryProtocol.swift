//
//  DatabaseCollectionQueryProtocol.swift
//
//

import Foundation
import Firebase

protocol AnyDatabaseCollection: Collection {
  associatedtype AnyDataModel: AnyDatabaseModel
  var snapshot: DataSnapshot { get }
}

extension AnyDatabaseCollection {
  typealias DataModel = AnyDataModel
  // MARK: - Indexes
  subscript(index: Int) -> DatabaseObject<DataModel>? {
    return object(at: index)
  }
  func index(of object: DatabaseObject<DataModel>) -> Int? {
    var result: Int?
    for (index, data) in snapshot.children.enumerated() {
      if let objectSnapshot = data as? DataSnapshot,
        objectSnapshot.key == object.reference.key {
        result = index
        break
      }
    }
    return result
  }
  var startIndex: Int {
    return 0
  }
  var endIndex: Int {
    let count: Int = Int(snapshot.childrenCount)
    if count > 0 {
      return count
    } else {
      return 0
    }
  }
  var count: Int {
    return Int(snapshot.childrenCount)
  }
  var arrayOfObjects: [DataModel]? {
    var array = [DataModel]()
    for element in snapshot.children.enumerated() {
      guard let objectSnapshot = element.element as? DataSnapshot,
      let objectModel: DataModel = objectSnapshot.toObjectDataModel()
      else { return nil }
      array.append(objectModel)
    }
    return array
  }
  //swiftlint:disable:next identifier_name
  func index(after i: Int) -> Int {
    let count: Int = Int(snapshot.childrenCount)
    if count > i {
      return i + 1
    } else {
      return i
    }
  }
  func object(withId objectId: String) -> DatabaseObject<DataModel>? {
    return objectIdWithIndex(withId: objectId)?.object
  }
  func objectIdWithIndex(withId objectId: String) -> (object: DatabaseObject<DataModel>, index: Int)? {
    let tempIndex: Int? = snapshot.children.allObjects.index { (element) -> Bool in
      guard let objectSnapshot = element as? DataSnapshot else { return false }
      return objectSnapshot.key == objectId
    }
    guard let index = tempIndex, let databaseObject = object(at: index) else { return nil }
    return (object: databaseObject, index: index)
  }
  func object(at index: Int) -> DatabaseObject<DataModel>? {
    guard
      snapshot.children.allObjects.count > index,
      index >= 0,
      let objectSnapshot = snapshot.children.allObjects[index] as? DataSnapshot,
      let json = objectSnapshot.uniqueEncoded
      else { return nil }
    let ref = objectSnapshot.ref
    do {
      let objectModel = try JSONDecoder().decode(DataModel.self, from: json)
      return DatabaseObject(reference: ref, dataModel: objectModel)
    } catch {
      
      print("\n\n\(objectSnapshot)\n\nerror = \(error)\n\n")
      return DatabaseObject(reference: ref, dataModel: nil)
    }
  }
}
