//
//  DatabaseObject.swift
//
//

import FirebaseDatabase

enum DatabaseObjectChange: AnyDatabseChange {
  case updated
}
final class DatabaseObject<DataModel: AnyDatabaseModel>: AnyDatabaseObject, AnyDatabaseModelObject, AnyDatabaseObservable {
// MARK: - Typealias
  typealias Model = DataModel
  typealias Query = DatabaseReference
  // MARK: - Properties
  var query: DatabaseReference
  var observeHandlerId: UInt?
  var authServiceHandlerId: Int?
  var observingHandlers: [Int: CompletionChangeHandler<DatabaseObjectChange>] = [:]
  var localisedStringObjects: [String: (Int, DatabaseObject<LocalisedString>)] = [:]
  var localisedContentObjects: [String: (Int, DatabaseObject<LocalisedString>)] = [:]
// MARK: - Private Properties
  fileprivate(set) var objectId: String?
  fileprivate(set) var dataModel: Model?
  fileprivate var dataSnapshot: DataSnapshot = DataSnapshot() {
    didSet { updateDataModel() }
  }
  // MARK: - Init
  convenience init(withId objectId: String) {
    let referencePath = DataModel.collectionRef(nil) + objectId
    self.init(referencePath: referencePath)
  }
  convenience init(referencePath: String) {
    let reference = FirebaseClient.databaseReference.child(referencePath)
    self.init(reference: reference)
  }
  convenience init(query anyQuery: DatabaseReference) {
    self.init(reference: anyQuery, dataModel: nil)
  }
  init(reference anyQuery: DatabaseReference?, dataModel initDataModel: DataModel?) {
    self.query = anyQuery ?? DatabaseReference()
    self.dataModel = initDataModel
    subscribeQuery(anyQuery: self.query)
  }
  deinit {
    self.unsubscribeQuery()
//    localizedObjects.forEach { $0.value.removeHandler(localizedHandlerIds[$0.key] ?? 0) }
  }
  // MARK: - Observe Method
  func observeNotification(snapshot: DataSnapshot) {
    self.dataSnapshot = snapshot
    self.notifyHandlers(about: .updated)
  }
}

// MARK: - Private
fileprivate extension DatabaseObject {
  func updateDataModel() {
    guard self.dataSnapshot.exists() else {
      self.dataModel = nil
      return
    }
    self.dataModel = dataSnapshot.toObjectDataModel()
  }
}
// MARK: - References
extension DatabaseObject where DataModel: AnyDatabaseModel {
  convenience init(id identifier: String, perentModel: AnyDatabaseModel?) {
    let referencePath = DataModel.collectionRef(perentModel) + identifier
    self.init(referencePath: referencePath)
  }
}
extension DatabaseObject where DataModel: LocalisedModel {
  convenience init(localizedStringId id: String) {
    let languagePath = SettingAppManager.shared.contentLanguage
    self.init(withId: id + "/\(languagePath)")
  }
}
