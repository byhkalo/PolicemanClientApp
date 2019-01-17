//
//  MainViewController.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 5/6/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class MainViewController: UIViewController {
  // MARK: - IBOutlet
  //  @IBOutlet var mainContentView: UIView!
  //  @IBOutlet var audioPlayerContentView: UIView!
  // MARK: - Properties
  /// Controlers for presenting
  let locationManager = CLLocationManager()
  /// business logic objects
  var viewModel: AnyMainViewModel! {
    didSet {
      guard oldValue !== self.viewModel else { return }
      if let oldValue = oldValue { unsubscribe(anyViewModel: oldValue) }
      if self.viewModel != nil { subscribe() }
    }
  }
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationTitle()
    isAuthorizedtoGetUserLocation()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  func isAuthorizedtoGetUserLocation() {
    
    if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  // MARK: - Text Edit Methods
  // MARK: - Actions
  @IBAction func myEmergenciesButtonPressed(_ sender: UIButton) {
    viewModel.myEmergenciesAction()
  }
  @IBAction func otherEmergenciesButtonPressed(_ sender: UIButton) {
    viewModel.otherEmergenciesAction()
  }
  @IBAction func profileButtonPressed(_ sender: UIButton) {
    viewModel.profileAction()
  }
  @IBAction func createEmergencyButtonPressed(_ sender: UIButton) {
    viewModel.createEmergency()
  }
}
// MARK: - Private Configuration
fileprivate extension MainViewController {
  func configureNavigationTitle() {
    self.navigationItem.hidesBackButton = true
    self.navigationItem.title = viewModel.navigationTitle
    navigationController?.navigationBar.tintColor = UIColor.white
    navigationController?.navigationBar.barTintColor =
      UIColor.init(red: 172.0/255.0, green: 18.0/255.0,
                   blue: 44.0/255.0, alpha: 1.0)
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
  }
}
// MARK: - Private Subscribe
fileprivate extension MainViewController {
  func subscribe() {
    viewModel.mainUpdateHandler = { (_) in }
  }
  func unsubscribe(anyViewModel: AnyMainViewModel) {
    anyViewModel.mainUpdateHandler = nil
  }
}

extension MainViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      print("User allowed us to access location")
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    }
  }
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let latitude = Float(location.coordinate.latitude)
    let longitude = Float(location.coordinate.longitude)
    viewModel.get(latitude: latitude, longitude: longitude)
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error \(error)")
  }
}
