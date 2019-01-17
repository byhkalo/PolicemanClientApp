//
//  LoginViewController.swift
//  BeaconMuseum
//
//  Created by Konstantyn Bykhkalo on 29.06.17.
//  Copyright © 2017 Bykhkalo Konstantyn. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  // MARK: - IBOutlet
  @IBOutlet var loginTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var signInButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  // MARK: - Properties
  var viewModel: AnyLoginViewModel! {
    didSet {
      guard oldValue !== self.viewModel else { return }
      if let oldValue = oldValue { unsubscribe(anyViewModel: oldValue) }
      if self.viewModel != nil { subscribe() }
    }
  }
  // MARK: - Init
  deinit {
    self.unsubscribe(anyViewModel: viewModel)
  }
  // MARK: - ViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    activityIndicator.stopAnimating()
  }
  // MARK: - Actions
  @IBAction func signInButtonPressed(_ sender: UIButton) {
    guard let email = loginTextField.text, let password = passwordTextField.text
      else { return }
    viewModel.loginWith(email: email, password: password)
  }
}
// MARK: - Private Subscribe
fileprivate extension LoginViewController {
  func unsubscribe(anyViewModel: AnyLoginViewModel) {
    anyViewModel.loginUpdateHandler = nil
  }
  func subscribe() {
    viewModel.loginUpdateHandler = { [weak self] change in
      guard let `self` = self else { return }
      switch change {
      case .userLogging:
        self.activityIndicator.startAnimating()
      case .userLogged:
        self.activityIndicator.stopAnimating()
      case .userLoggedError(let errorText):
        self.activityIndicator.stopAnimating()
        self.showAlert(withTitle: "Error", message: errorText)
      case .none: break
      }
    }
  }
}
// MARK: - Private Help Methods
fileprivate extension LoginViewController {
  func showAlert(withTitle title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
