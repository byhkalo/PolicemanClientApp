//
//  StorageDataCleaner.swift
//
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

final class StorageDataCleaner {
  // MARK: - Public
  //  - Delete By URL
  func deleteMedia(from referenceUrl: String, completion: @escaping CompletionErrorHandler) {
    let storageRef = Storage.storage().reference(forURL: referenceUrl)
    deleteMedia(from: storageRef, completion: completion)
  }
  //  - Delete By Storage Reference Object
  func deleteMedia(from referenceStorage: StorageReference, completion: @escaping CompletionErrorHandler) {
    referenceStorage.delete { completion($0) }
  }
}
