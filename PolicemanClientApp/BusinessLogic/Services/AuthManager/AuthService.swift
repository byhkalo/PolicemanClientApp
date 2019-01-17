//
//  AuthService.swift
//
//

import Foundation
import Firebase
import FirebaseAuth

protocol AnyAuthService {
  var userId: String? { get }
  func isLogged() -> Bool
  func loginWith(email: String, password: String,
                 completion: @escaping CompletionResponseHandler<User>)
}

class AuthService {
  static let shared = AuthService()
}

extension AuthService: AnyAuthService {
  var userId: String? {
    return Auth.auth().currentUser?.uid
  }
  func isLogged() -> Bool {
    return Auth.auth().currentUser != nil
  }
  func loginWith(email: String, password: String,
                 completion: @escaping CompletionResponseHandler<User>) {
    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
      completion(authResult?.user, error)
    }
  }
}
