//
//  FirebaseClient.swift
//
//

import FirebaseStorage
import FirebaseDatabase
import Firebase

final class FirebaseClient {
  // MARK: - Properties
  static var databaseReference: DatabaseReference {
    return Database.database().reference()
  }
  static var storageReference: StorageReference {
    return Storage.storage(app: self.app).reference()
  }
  static var app: FirebaseApp {
    return FirebaseApp.app()!
  }
  // MARK: - Public
  static func configure() {
    FirebaseApp.configure()
    Database.database().isPersistenceEnabled = false
    configureRemoteConfig()
  }
  private static func configureRemoteConfig() {
    /// 3600 = 1 hour in seconds
//    RemoteConfig.remoteConfig().fetch(withExpirationDuration: 3600) { (_, error) in
//      guard error == nil else { return }
//      RemoteConfig.remoteConfig().activateFetched()
//    }
  }
}
