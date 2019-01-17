//
//  DataBaseCollection.swift
//
//

import FirebaseDatabase

enum DatabaseCollectionChange: AnyDatabseChange {
  case updated
  // MARK: - Equatable
  public static func == (lhs: DatabaseCollectionChange, rhs: DatabaseCollectionChange) -> Bool {
    switch lhs.hashValue {
    case rhs.hashValue: return true
    default: return false
    }
  }
}
final class DatabaseCollection<DataModel: AnyDatabaseModel>: AnyDatabaseObject,
AnyDatabaseObservable, AnyDatabaseCollection, AnyDatabaseQueryErrorHandler {
// MARK: - Typealias
  typealias AnyDataModel = DataModel
  typealias Query = DatabaseReference
// MARK: - Properties
  var query: DatabaseReference
  var observeHandlerId: UInt?
  var authServiceHandlerId: Int?
  var observingHandlers: [Int: CompletionChangeHandler<DatabaseCollectionChange>] = [:]
// MARK: - Private Properties
  fileprivate(set) var initialLoad: Bool = true
  fileprivate(set) var snapshot: DataSnapshot = DataSnapshot()
  var localizedDict: [String: [String: String]] = [:]
// MARK: - Init
  required init(query anyQuery: Query) {
    self.query = anyQuery
    subscribeQuery(anyQuery: self.query)
  }
  convenience init(perentObject: AnyDatabaseModel? = nil) {
    let referencePath = "\(DataModel.collectionRef(perentObject))"
    let reference = FirebaseClient.databaseReference.child(referencePath)
    self.init(reference: reference)
  }
  deinit {
    unsubscribeQuery()
    observingHandlers.removeAll()
  }
// MARK: - Observe Method
  func observeNotification(snapshot: DataSnapshot) {
    initialLoad = false
    self.snapshot = snapshot
    self.notifyHandlers(about: .updated)
  }
  func observeWithError(error: Error) {
    initialLoad = false
  }
// MARK: - Managing collection
  func addNewModel(id: String, orderModel: DataModel) {
//    reference.child(id).updateChildValues(orderModel.toDatabaseJSON())
  }
  func removeModel(for id: String) {
    reference.child(id).removeValue()
  }
}
