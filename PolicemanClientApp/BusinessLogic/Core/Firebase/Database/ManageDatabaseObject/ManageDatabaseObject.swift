//
//  ManageDatabaseObject.swift
//
//

import Foundation
import Firebase

final class ManageDatabaseObject<DataModel: AnyDatabaseModel> {
// MARK: - Propeties
  let databaseObject: DatabaseObject<DataModel>
  var reference: DatabaseReference {
    return databaseObject.reference
  }
// MARK: - Init
  init(databaseObject: DatabaseObject<DataModel>) {
    self.databaseObject = databaseObject
  }
// MARK: - Manage Object
  func updateModel(_ model: DataModel) {
    guard let databaseJson = model.toDatabaseJSON() else { return }
    reference.updateChildValues(databaseJson)
  }
}
