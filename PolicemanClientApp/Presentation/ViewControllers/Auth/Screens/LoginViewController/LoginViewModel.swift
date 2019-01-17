//
//  LoginViewModel.swift
//  BeaconMuseum
//
//  Created by Konstantyn Bykhkalo on 29.06.17.
//  Copyright © 2017 Bykhkalo Konstantyn. All rights reserved.
//

import UIKit

enum LoginChange {
  case none
  case userLogged
  case userLogging
  case userLoggedError(String)
}

typealias LoginUpdateHandler = CompletionChangeHandler<LoginChange>

protocol AnyLoginViewModel: class {
  /// Properties
  var loginUpdateHandler: LoginUpdateHandler? { get set }
  ///Museum Info
  func loginWith(email: String, password: String)
}

class LoginViewModel {
  // MARK: - Properties
  var loginUpdateHandler: LoginUpdateHandler?
  // MARK: - Private Properties
  /// Context & Services
  fileprivate var context: AnyAuthObservableFlowContext
  fileprivate weak var router: AnyAuthRouter?
  fileprivate let authService: AnyAuthService
  // MARK: - Init
  init(context: AnyAuthObservableFlowContext, router: AnyAuthRouter, authService: AnyAuthService) {
    self.context = context
    self.router = router
    self.authService = authService
    subcribeHandlers()
  }
  deinit {
    unsubcribeHandlers()
  }
}

private extension LoginViewModel {
  func subcribeHandlers() { }
  func unsubcribeHandlers() { }
  func notifyUpdate(_ change: LoginChange) {
    self.loginUpdateHandler?(change)
  }
}

extension LoginViewModel: AnyLoginViewModel {
  func loginWith(email: String, password: String) {
    notifyUpdate(.userLogging)
    authService.loginWith(email: email, password: password) { (fireUser, error) in
      if let userId = fireUser?.uid {
        self.notifyUpdate(.userLogged)
        self.context.policemanObject = DatabaseObject(withId: userId)
        self.router?.beginMainFlow()
      } else if let error = error {
        self.notifyUpdate(.userLoggedError(error.localizedDescription))
      } else {
        self.notifyUpdate(.userLoggedError("Unknowed error"))
      }
    }
  }
}
