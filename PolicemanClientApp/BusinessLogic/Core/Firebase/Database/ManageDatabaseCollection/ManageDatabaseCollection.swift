//
//  ManageDatabaseCollection.swift
//
//

import Foundation
import Firebase

//class ManageDatabaseCollectionQuery<DatabaseModel: AnyDatabaseModel>: AnyManageDatabaseCollection {
//  typealias DataModel = DatabaseModel
//  let databaseCollectionQuery: DatabaseCollectionQuery<DataModel>
//  var reference: DatabaseReference {
//    return databaseCollectionQuery.query.ref
//  }
//  // MARK: - Init
//  init(databaseCollectionQuery: DatabaseCollectionQuery<DataModel>) {
//    self.databaseCollectionQuery = databaseCollectionQuery
//  }
//}

class ManageDatabaseCollection<DatabaseModel: AnyDatabaseModel>: AnyManageDatabaseCollection {
  typealias DataModel = DatabaseModel
  // MARK: - Private Properties
  let databaseCollection: DatabaseCollection<DataModel>
  var reference: DatabaseReference {
    return databaseCollection.reference
  }
  // MARK: - Init
  init(databaseCollection: DatabaseCollection<DataModel>) {
    self.databaseCollection = databaseCollection
  }
}
//DatabaseCollectionManageable
protocol AnyManageDatabaseCollection {
  associatedtype DataModel: AnyDatabaseModel
  var reference: DatabaseReference { get }
}

extension AnyManageDatabaseCollection {
  // MARK: - Add Methods
  func addModel(_ model: DataModel) {
    addModels([model])
  }
  func addModels(_ models: [DataModel]) {
    var modelDict: [String: [String: Any]] = [:]
    models.forEach({ dataModel in
      if let modelDictionary = dataModel.dictionary {
        modelDict[dataModel.identifier] = modelDictionary
      }
    })
    print("\n\n\nmodelDict = \(modelDict)\n\n\n")
    reference.updateChildValues(modelDict)
  }
  // MARK: - Remove Methods
  func removeModel(_ model: DataModel) {
    removeModels([model])
  }
  func removeModels(_ models: [DataModel]) {
    var childRemove: [String: NSNull] = [:]
    models.forEach { childRemove[$0.identifier] = NSNull() }
    reference.updateChildValues(childRemove)
  }
  // MARK: - Update Methods
  func updateModel(_ model: DataModel) {
    updateModels([model])
  }
  func updateModels(_ models: [DataModel]) {
    var modelDict: [String: [String: Any]] = [:]
    models.forEach({ dataModel in
      if let modelDictionary = dataModel.dictionary {
        modelDict[dataModel.identifier] = modelDictionary
      }
    })
    reference.updateChildValues(modelDict)
  }
}
