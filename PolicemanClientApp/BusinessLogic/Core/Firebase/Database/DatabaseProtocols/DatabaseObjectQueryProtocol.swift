//
//  DatabaseObjectQueryProtocol.swift
//
//

import Foundation
import FirebaseDatabase

// MARK: - AnyDatabaseQuery

protocol AnyDatabaseQuery: class {
  associatedtype Query: DatabaseQuery
  var query: Query { get set }
  // Observing
  init(query anyQuery: Query)
  var observeHandlerId: UInt? { get set }
  func observeNotification(snapshot: DataSnapshot)
  // Shouldn't implement this methods
  func subscribeQuery(anyQuery newQuery: Query)
  func unsubscribeQuery()
  func subscribeQuery()
}
protocol AnyDatabaseQueryErrorHandler: class {
  func observeWithError(error: Error)
}

// MARK: - AnyDatabaseObject

protocol AnyDatabaseObject: AnyDatabaseQuery {
  var reference: Query { get set }
}

// MARK: - AnyDatabaseObject Extension

extension AnyDatabaseObject {
  var reference: Query {
    get { return query }
    set { query = newValue }
  }
  init(reference: Query?) {
    let initReference = reference ?? Query()
    self.init(query: initReference)
  }
}

// MARK: - AnyDatabaseQuery Extension

extension AnyDatabaseQuery {
  func subscribeQuery(anyQuery newQuery: Query) {
    guard newQuery != self.query || observeHandlerId == nil else { return }
    unsubscribeQuery()
    self.query = newQuery
    subscribeQuery()
  }
  func unsubscribeQuery() {
    if let observeHandlerId = observeHandlerId {
      self.query.removeObserver(withHandle: observeHandlerId)
    }
  }
  func subscribeQuery() {
    self.observeHandlerId = self.query.observe(.value, with: { [weak self] snapshot in
      self?.observeNotification(snapshot: snapshot)
      }, withCancel: { [weak self] error in
        guard let `self` = self else { return }
        if let errorHandler = self as? AnyDatabaseQueryErrorHandler {
          errorHandler.observeWithError(error: error)
        }
    })
  }
}
