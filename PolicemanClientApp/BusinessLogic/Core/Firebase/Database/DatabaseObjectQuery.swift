//
//  DatabaseObjectQuery.swift
//
//

import FirebaseDatabase

enum DatabaseObjectQueryChange: AnyDatabseChange {
  case updated
  // MARK: - Equatable
  public static func == (lhs: DatabaseObjectQueryChange, rhs: DatabaseObjectQueryChange) -> Bool {
    switch lhs.hashValue {
    case rhs.hashValue: return true
    default: return false
    }
  }
}
class DatabaseObjectQuery<DataModel: AnyDatabaseModel>: AnyDatabaseQuery, AnyDatabaseModelObject, AnyDatabaseObservable {
  typealias Query = DatabaseQuery
  typealias Model = DataModel
  var query: DatabaseQuery
  fileprivate(set) var dataModel: Model?
  var observeHandlerId: UInt?
  var observingHandlers: [Int: CompletionChangeHandler<DatabaseObjectQueryChange>] = [:]
  /// Keep fresh data of query
  fileprivate var dataSnapshot: DataSnapshot = DataSnapshot() {
    didSet {
      updateDataModel()
    }
  }
  required init(query anyQuery: Query) {
    self.query = anyQuery
    subscribeQuery(anyQuery: self.query)
  }
//  static func objectQuery(forId objectId: String) -> DatabaseObjectQuery<DataModel> where DataModel == AnyLowLevelDatabaseModel {
//    let objectsCollection = FirebaseClient.databaseReference.child(DataModel.baseRef(topLevelKey: nil))
//    let query = objectsCollection.queryOrderedByKey().queryEqual(toValue: objectId)
//    return DatabaseObjectQuery<DataModel>(query: query)
//  }
  func observeNotification(snapshot: DataSnapshot) {
    self.dataSnapshot = snapshot
    self.notifyHandlers(about: .updated)
  }
}
fileprivate extension DatabaseObjectQuery {
  // MARK: - Private
  func updateDataModel() {
    self.dataModel = self.dataSnapshot.toObjectDataModel()
  }
}
