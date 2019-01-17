//
//  LaunchFlowCoordinator.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 4/30/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation
import UIKit

protocol AnyLaunchRouter: class {
  func beginMainFlow()
  func beginAuthFlow()
}

class LaunchFlowCoordinator: FlowCoordinator<UINavigationController, AnyLaunchObservableFlowContext> {
  // MARK: - Private Properties
  fileprivate var launchViewController: LaunchViewController!
  fileprivate var mainFlowCoordinator: MainFlowCoordinator!
  fileprivate var authFlowCoordinator: AuthFlowCoordinator!
  // MARK: - Public
  override func start() {
    startLaunchFlow()
  }
}

private extension LaunchFlowCoordinator {
  func startLaunchFlow() {
    guard let currentLaunchViewController = rootController.viewControllers.first as? LaunchViewController
      else { return }
    launchViewController = currentLaunchViewController
    launchViewController.model = LaunchViewModel(
      context: context, router: self, authService: context.authService)
  }
  func startMainFlow() {
    guard let mainContext = context.mainContext else { return }
    if mainFlowCoordinator == nil {
      mainFlowCoordinator = MainFlowCoordinator(rootController: rootController, context: mainContext)
    }
    DispatchQueue.main.async {
      self.mainFlowCoordinator.start()
    }
  }
  func startAuthFlow() {
    if authFlowCoordinator == nil {
      authFlowCoordinator = AuthFlowCoordinator(rootController: rootController, context: context.authContext)
    }
    DispatchQueue.main.async {
      self.authFlowCoordinator.start()
    }
  }
}

extension LaunchFlowCoordinator: AnyLaunchRouter {
  func beginMainFlow() {
    startMainFlow()
  }
  func beginAuthFlow() {
    startAuthFlow()
  }
}
