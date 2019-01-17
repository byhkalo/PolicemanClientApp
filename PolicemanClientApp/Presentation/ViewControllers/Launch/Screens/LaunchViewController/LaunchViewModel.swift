//
//  LaunchViewModel.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 4/30/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation
import SDWebImage

enum LaunchChange {
  case none
  case update
}

typealias LaunchUpdateHandler = CompletionChangeHandler<LaunchChange>

protocol AnyLaunchViewModel: class {
  /// Properties
  var launchUpdateHandler: LaunchUpdateHandler? { get set }
}
// MARK: - LaunchViewModel
class LaunchViewModel {
  // MARK: - Properties
  var launchUpdateHandler: LaunchUpdateHandler?
  // MARK: - Private Properties
  fileprivate(set) var context: AnyLaunchObservableFlowContext
  fileprivate var authService: AnyAuthService
  fileprivate(set) weak var router: AnyLaunchRouter?
  fileprivate var museumHandlerId: Int = 0
  // MARK: - Init
  init(context: AnyLaunchObservableFlowContext, router: AnyLaunchRouter,
       authService: AnyAuthService) {
    self.context = context
    self.router = router
    self.authService = authService
    subcribeHandlers()
    checkAuthentication()
  }
  deinit {
    unsubcribeHandlers()
  }
}
// MARK: - Private Handlers
private extension LaunchViewModel {
  func subcribeHandlers() { }
  func unsubcribeHandlers() { }
  func checkAuthentication() {
    if authService.isLogged(), let userId = authService.userId {
      context.policemanObject = DatabaseObject(withId: userId)
      router?.beginMainFlow()
    } else {
      router?.beginAuthFlow()
    }
  }
  func notifyUpdate(_ change: LaunchChange) {
    self.launchUpdateHandler?(change)
  }
}

extension LaunchViewModel: AnyLaunchViewModel {
}
