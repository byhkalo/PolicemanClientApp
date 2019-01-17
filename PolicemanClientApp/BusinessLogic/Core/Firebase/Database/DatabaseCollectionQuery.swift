//
//  DatabaseCollectionQuery.swift
//
//

import FirebaseDatabase

enum DatabaseCollectionQueryChange: AnyDatabseChange {
  case updated
  // MARK: - Equatable
  public static func == (lhs: DatabaseCollectionQueryChange, rhs: DatabaseCollectionQueryChange) -> Bool {
    switch lhs.hashValue {
    case rhs.hashValue: return true
    default: return false
    }
  }
}

final class DatabaseCollectionQuery<DataModel: AnyDatabaseModel>: AnyDatabaseQuery, AnyDatabaseObservable, AnyDatabaseCollection {
// MARK: - Typealias
  typealias AnyDataModel = DataModel
  typealias Query = DatabaseQuery
// MARK: - Properties
  var query: DatabaseQuery
  var observeHandlerId: UInt?
  var authServiceHandlerId: Int?
  var observingHandlers: [Int: CompletionChangeHandler<DatabaseCollectionChange>] = [:]
// MARK: - Private Properties
  fileprivate(set) var initialLoad: Bool = true
  fileprivate(set) var key: String = ""
  fileprivate(set) var value: Any?
  fileprivate(set) var snapshot: DataSnapshot = DataSnapshot()
// MARK: - Init
  convenience init(key: String = "", value: Any? = nil) {
    let ref = FirebaseClient.databaseReference.child(DataModel.collectionRef(nil))
    var query = ref.queryOrdered(byChild: key)
    if let value = value {
      query = query.queryEqual(toValue: value)
    }
    self.init(query: query)
    self.key = key
    self.value = value
  }
  required init(query anyQuery: Query) {
    self.query = anyQuery
    subscribeQuery(anyQuery: self.query)
  }
  deinit {
    observingHandlers.removeAll()
  }
// MARK: - Observe Method
  func observeNotification(snapshot: DataSnapshot) {
    initialLoad = false
    self.snapshot = snapshot
    self.notifyHandlers(about: .updated)
  }
}
