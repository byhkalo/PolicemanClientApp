//
//  EmergencyFlowCoordinator.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit

protocol AnyEmergencyRouter: class {
  func closeMyEmergenciesScreen()
  func closeOtherEmergenciesScreen()
  func closeDetailEmergenciesScreen()
  func showDetailEmergency()
}

class EmergencyFlowCoordinator: FlowCoordinator<UINavigationController, AnyEmergencyObservableFlowContext> {
  // MARK: - Private Properties
  fileprivate var myEmergenciesViewController: EmergenciesViewController!
  fileprivate var otherEmergenciesViewController: EmergenciesViewController!
  fileprivate var detailEmergenciesViewController: DetailEmergencyViewController!
  // MARK: - Public
  override func start() {
  }
  func startMyEmergencies() {
    let viewModel = MyEmergenciesViewModel(context: context, router: self)
    let displayCollection = EmergenciesDisplayCollection(viewModel)
    myEmergenciesViewController = EmergenciesViewController()
    if myEmergenciesViewController.viewModel == nil {
      myEmergenciesViewController.viewModel = viewModel
    }
    if myEmergenciesViewController.displayCollection == nil {
      myEmergenciesViewController.displayCollection = displayCollection
    }
    rootController.pushViewController(myEmergenciesViewController, animated: true)
  }
  func startOtherEmergencies() {
    let viewModel = OtherEmergenciesViewModel(context: context, router: self)
    let displayCollection = EmergenciesDisplayCollection(viewModel)
    otherEmergenciesViewController = EmergenciesViewController()
    if otherEmergenciesViewController.viewModel == nil {
      otherEmergenciesViewController.viewModel = viewModel
    }
    if otherEmergenciesViewController.displayCollection == nil {
      otherEmergenciesViewController.displayCollection = displayCollection
    }
    rootController.pushViewController(otherEmergenciesViewController, animated: true)
  }
  func startDetailEmergency() {
    guard let selectedEmergency = context.selectedEmergency else { return }
    let viewModel = DetailEmergencyViewModel(context: context, router: self,
                                             emergency: selectedEmergency)
    detailEmergenciesViewController = DetailEmergencyViewController()
    if detailEmergenciesViewController.viewModel == nil {
      detailEmergenciesViewController.viewModel = viewModel
    }
    rootController.pushViewController(detailEmergenciesViewController, animated: true)
  }
}
// MARK: - extension AnyEmergencyRouter
extension EmergencyFlowCoordinator: AnyEmergencyRouter {
  func closeMyEmergenciesScreen() {
    rootController.popToViewController(myEmergenciesViewController, animated: true)
  }
  func closeOtherEmergenciesScreen() {
    rootController.popToViewController(otherEmergenciesViewController, animated: true)
  }
  func closeDetailEmergenciesScreen() {
    rootController.popToViewController(detailEmergenciesViewController, animated: true)
  }
  func showDetailEmergency() {
    startDetailEmergency()
  }
}
