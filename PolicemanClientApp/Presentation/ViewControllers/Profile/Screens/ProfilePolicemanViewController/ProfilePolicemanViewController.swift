//
//  ProfilePolicemanViewController.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ProfilePolicemanViewController: UIViewController {
  // MARK: IBOutlet
  @IBOutlet weak var policemanNameLabel: UILabel!
  @IBOutlet weak var identifierLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var isAdminLabel: UILabel!
  @IBOutlet var isActiveSwitch: UISwitch!
  @IBOutlet var mapView: MKMapView!
  var currentAnnotation: MKPointAnnotation?
  // MARK: - Properties
  var viewModel: AnyProfilePolicemanViewModel! {
    didSet {
      guard oldValue !== self.viewModel else { return }
      if let oldValue = oldValue { unsubscribe(anyViewModel: oldValue) }
      if self.viewModel != nil { subscribe() }
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    updatePolicemanInfo()
    configureNavigationTitle()
  }
  // MARK: - Actions
  @IBAction func activityStatusChanged(_ sender: UISwitch) {
    viewModel.activeStateChanged(to: sender.isOn)
  }
}
// MARK: - Configuration
private extension ProfilePolicemanViewController {
  func updatePolicemanInfo() {
    policemanNameLabel.text = viewModel.policemanName
    identifierLabel.text = viewModel.identifier
    latitudeLabel.text = viewModel.latitude
    longitudeLabel.text = viewModel.longitude
    isAdminLabel.text = viewModel.isAdmin ? "True" : "False"
    isActiveSwitch.isOn = viewModel.isActive
    let lat = CLLocationDegrees(viewModel.latitudeFloat)
    let long = CLLocationDegrees(viewModel.longitudeFloat)
    let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    mapView.centerCoordinate = centerCoordinate
    if let currentAnnotation = currentAnnotation {
      mapView.removeAnnotation(currentAnnotation)
    }
    currentAnnotation = MKPointAnnotation()
    currentAnnotation?.coordinate = centerCoordinate
    mapView.addAnnotation(currentAnnotation!)
    
    let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    let region = MKCoordinateRegion(center: centerCoordinate, span: span)
    mapView.region = region
    
  }
  func configureMap() {
  }
  func configureNavigationTitle() {
    self.navigationItem.title = viewModel.navigationTitle
  }
}
// MARK: - Private Subscribe
fileprivate extension ProfilePolicemanViewController {
  func unsubscribe(anyViewModel: AnyProfilePolicemanViewModel) {
    anyViewModel.profilePolicemanUpdateHandler = nil
  }
  func subscribe() {
    viewModel.profilePolicemanUpdateHandler = { [weak self] change in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch change {
        case .node: break
        case .activityChanged: break
        case .policemanUpdated:
          self.updatePolicemanInfo()
        }
      }
    }
  }
}
