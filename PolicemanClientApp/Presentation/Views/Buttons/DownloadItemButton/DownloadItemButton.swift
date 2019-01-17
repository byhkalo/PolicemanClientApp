//
//  DownloadItemButton.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 5/4/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation
import UIKit

class DownloadItemButton: UIButton {
  // MARK: - IBOutlet
  @IBOutlet var largeDownloadLabel: UILabel!
  @IBOutlet var detailLabel: UILabel!
  // MARK: - For loading from Nib
  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return self.loadFromNibIfEmbeddedInDifferentNib()
  }
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  // MARK: - Fix touches
  override func hitTest(_ point: CGPoint,
                        with event: UIEvent?) -> UIView? {
    return self
  }
  // MARK: - Update Language
  func updateApplicationLanguage() {
    largeDownloadLabel.text = TxGn.Download
    detailLabel.text = TxGn.theEntireStory
  }
}
