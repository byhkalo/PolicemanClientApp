//
//  ProfileFlowCoordinator.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit

protocol AnyProfileRouter: class {
  func closeProfileScreen()
}

class ProfileFlowCoordinator: FlowCoordinator<UINavigationController, AnyProfileObservableFlowContext> {
  // MARK: - Private Properties
  fileprivate var profilePolicemanViewController: ProfilePolicemanViewController!
  // MARK: - Public
  override func start() {
    let viewModel = ProfilePolicemanViewModel(context: context, router: self,
                                              policemanObject: context.policamanObject)
    profilePolicemanViewController = ProfilePolicemanViewController()
    if profilePolicemanViewController.viewModel == nil {
      profilePolicemanViewController.viewModel = viewModel
    }
    rootController.pushViewController(profilePolicemanViewController, animated: true)
  }
}

// MARK: - extension AnyProfileRouter
extension ProfileFlowCoordinator: AnyProfileRouter {
  func closeProfileScreen() {
    rootController.popViewController(animated: true)
  }
}
