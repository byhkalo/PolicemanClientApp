//
//  LaunchViewController.swift
//  MagiColoride
//
//  Created by Konstantyn Byhkalo on 3/16/17.
//  Copyright © 2017 Bykhkalo Konstantyn. All rights reserved.
//

import UIKit
import Firebase

class LaunchViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet var logoImageView: UIImageView!
  // MARK: - Properties
  var model: AnyLaunchViewModel!
  // MARK: - ViewController lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
