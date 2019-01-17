//
//  MainFlowCoordinator.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 5/6/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation
import UIKit

protocol AnyMainRouter: class {
  func presentMyEmergencies()
  func presentOtherEmergencies()
  func presentProfile()
}

class MainFlowCoordinator: FlowCoordinator<UINavigationController, AnyMainObservableFlowContext> {
  // MARK: - Private Properties
  fileprivate var mainViewController: MainViewController!
  
  fileprivate var emergenciesFlowCoordinator: EmergencyFlowCoordinator!
  fileprivate var profileFlowCoordinator: ProfileFlowCoordinator!
  // MARK: - Public
  override func start() {
    startMainFlow()
  }
}
// MARK: - Private Flow Methods
private extension MainFlowCoordinator {
  func startMainFlow() {
    let viewModel = MainViewModel(context: context, router: self)
    let mainViewController = MainViewController()
    if mainViewController.viewModel == nil {
      mainViewController.viewModel = viewModel
    }
    self.rootController.pushViewController(mainViewController, animated: false)
    //    mainViewController.navigationItem.hidesBackButton = false
  }
  func startMyEmergenciesFlow() {
    if emergenciesFlowCoordinator == nil {
      emergenciesFlowCoordinator = EmergencyFlowCoordinator(rootController: rootController,
                                                            context: context.myEmergenciesContext)
    }
    DispatchQueue.main.async {
      self.emergenciesFlowCoordinator.startMyEmergencies()
    }
  }
  func startOtherEmergenciesFlow() {
    if emergenciesFlowCoordinator == nil {
      emergenciesFlowCoordinator = EmergencyFlowCoordinator(rootController: rootController,
                                                            context: context.otherEmergenciesContext)
    }
    DispatchQueue.main.async {
      self.emergenciesFlowCoordinator.startOtherEmergencies()
    }
  }
  func startProfileFlow() {
    if profileFlowCoordinator == nil {
      profileFlowCoordinator = ProfileFlowCoordinator(rootController: rootController,
                                                      context: context.profileContext)
    }
    DispatchQueue.main.async {
      self.profileFlowCoordinator.start()
    }
  }
}

extension MainFlowCoordinator: AnyMainRouter {
  func presentMyEmergencies() {
    startMyEmergenciesFlow()
  }
  func presentOtherEmergencies() {
    startOtherEmergenciesFlow()
  }
  func presentProfile() {
    startProfileFlow()
  }
}

