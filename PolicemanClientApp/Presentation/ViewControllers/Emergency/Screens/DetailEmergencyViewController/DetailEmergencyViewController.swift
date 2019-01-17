//
//  DetailEmergencyViewController.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailEmergencyViewController: UIViewController {
  // MARK: IBOutlet
  @IBOutlet var identifierLabel: UILabel!
  @IBOutlet var requestPersonLabel: UILabel!
  @IBOutlet var requestTimeLabel: UILabel!
  @IBOutlet var locationLabel: UILabel!
  @IBOutlet var infoLabel: UILabel!
  @IBOutlet var isRequestAmbulanceLabel: UILabel!
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var navigateToButton: UIButton!
  @IBOutlet var acceptEmergencyButton: UIButton!
  @IBOutlet var activateEmergencyButton: UIButton!
  @IBOutlet var requestAmbulanceButton: UIButton!
  // MARK: - Properties
  var currentAnnotation: MKPointAnnotation?
  var viewModel: AnyDetailEmergencyViewModel! {
    didSet {
      guard oldValue !== self.viewModel else { return }
      if let oldValue = oldValue { unsubscribe(anyViewModel: oldValue) }
      if self.viewModel != nil { subscribe() }
    }
  }
  // MARK: - ViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    updateEmergencyInfo()
    configureNavigationTitle()
  }
  // MARK: - Actions
  @IBAction func navigateToButtonPressed(_ sender: UISwitch) {
    viewModel.navigateToAction()
  }
  @IBAction func acceptEmergencyButtonPressed(_ sender: UIButton) {
    viewModel.acceptEmergencyAction()
  }
  @IBAction func activateEmergencyButtonPressed(_ sender: UIButton) {
    viewModel.activateEmergencyAction()
  }
  @IBAction func requestAmbulanceButtonPressed(_ sender: UIButton) {
    viewModel.requestAmbulanceAction()
  }
}
// MARK: - Configuration
private extension DetailEmergencyViewController {
  func updateEmergencyInfo() {
    identifierLabel.text = viewModel.identifier
    locationLabel.text = viewModel.location
    requestPersonLabel.text = viewModel.requestPerson
    requestTimeLabel.text = viewModel.requestTime
    infoLabel.text = viewModel.infoText
    isRequestAmbulanceLabel.text = viewModel.isRequestAmbulance ? "TRUE" : "FALSE"
    acceptEmergencyButton.isEnabled = (viewModel.isActivatedEmergency
      && !viewModel.isAcceptedEmergency)
    activateEmergencyButton.isEnabled = !viewModel.isActivatedEmergency
    requestAmbulanceButton.isEnabled = !viewModel.isRequestAmbulance
    updateMap()
  }
  func updateMap() {
    let lat = CLLocationDegrees(viewModel.latitude)
    let long = CLLocationDegrees(viewModel.longitude)
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
  func configureNavigationTitle() {
    self.navigationItem.title = viewModel.navigationTitle
  }
}
// MARK: - Private Subscribe
fileprivate extension DetailEmergencyViewController {
  func unsubscribe(anyViewModel: AnyDetailEmergencyViewModel) {
    anyViewModel.detailEmergencyUpdateHandler = nil
  }
  func subscribe() {
    viewModel.detailEmergencyUpdateHandler = { [weak self] change in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch change {
        case .node: break
        case .emergencyUpdated: self.updateEmergencyInfo()
        case .policemanUpdated: break
        }
      }
    }
  }
}

