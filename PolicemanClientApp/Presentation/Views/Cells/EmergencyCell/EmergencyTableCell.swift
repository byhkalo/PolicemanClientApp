//
//  EmergencyTableCell.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/15/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit

enum EmergencyTableCellAction: AnyUserAction {
  case getAction
}

class EmergencyTableCell: UITableViewCell, AnyActionView {
  // MARK: - IBOutlets
  /// Labels
  @IBOutlet fileprivate(set) var identifierLabel: UILabel!
  @IBOutlet fileprivate(set) var latitudeLabel: UILabel!
  @IBOutlet fileprivate(set) var longitudeLabel: UILabel!
  @IBOutlet fileprivate(set) var requestPersonLabel: UILabel!
  @IBOutlet fileprivate(set) var requestTimeLabel: UILabel!
  // MARK: - AnyActionView Properties
  weak var actionsDelegate: AnyActionViewDelegate?
  // MARK: - Init from Nib
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  // MARK: - Actions
  @IBAction func getButtonPressed(_ sender: UIButton) {
    actionsDelegate?.actionView(self, didAction: GuideDetailTableCellAction.getAction)
  }
}

