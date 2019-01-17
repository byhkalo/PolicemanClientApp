//
//  AuthFlowCoordinator.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/13/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit

protocol AnyAuthRouter: class {
  func beginMainFlow()
}

class AuthFlowCoordinator: FlowCoordinator<UINavigationController, AnyAuthObservableFlowContext> {
  // MARK: - Private Properties
  fileprivate var loginViewController: LoginViewController!
  fileprivate var mainFlowCoordinator: MainFlowCoordinator!
  fileprivate var authFlowCoordinator: AuthFlowCoordinator!
  // MARK: - Public
  override func start() {
    startAuthFlow()
  }
}

private extension AuthFlowCoordinator {
  func startAuthFlow() {
    loginViewController = LoginViewController()
    let viewModel = LoginViewModel(context: context, router: self,
                                   authService: context.authService)
    if loginViewController.viewModel == nil {
      loginViewController.viewModel = viewModel
    }
//    rootController.pushViewController(loginViewController, animated: true)
    rootController.showDetailViewController(loginViewController, sender: nil)
  }
  func startMainFlow() {
    guard let mainContext = context.mainContext else { return }
    if mainFlowCoordinator == nil {
      mainFlowCoordinator = MainFlowCoordinator(rootController: rootController, context: mainContext)
    }
    DispatchQueue.main.async {
      self.loginViewController.dismiss(animated: true, completion: {
          self.mainFlowCoordinator.start()
      })
    }
  }
}

extension AuthFlowCoordinator: AnyAuthRouter {
  func beginMainFlow() {
    startMainFlow()
  }
}

