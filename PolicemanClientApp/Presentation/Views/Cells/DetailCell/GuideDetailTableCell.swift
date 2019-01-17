//
//  GuideDetailTableCell.swift
//  BeaconMuseum
//
//  Created by Konstantyn Bykhkalo on 30.06.17.
//  Copyright © 2017 Bykhkalo Konstantyn. All rights reserved.
//

import UIKit

enum GuideDetailTableCellAction: AnyUserAction {
  case getAction
  case playAction
}

class GuideDetailTableCell: UITableViewCell, AnyActionView {
  // MARK: - IBOutlets
  /// Labels
  @IBOutlet fileprivate(set) var trackName: UILabel!
  @IBOutlet fileprivate(set) var trackNumber: UILabel!
  @IBOutlet fileprivate(set) var trackDuration: UILabel!
  /// Spinner
  @IBOutlet fileprivate(set) weak var spinner: UIActivityIndicatorView!
  /// Buttons
  @IBOutlet fileprivate(set) weak var downloadButton: UIButton!
  @IBOutlet fileprivate(set) weak var playButton: UIButton!
  // MARK: - AnyActionView Properties
  weak var actionsDelegate: AnyActionViewDelegate?
  // MARK: - Init from Nib
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  // MARK: - Actions
  @IBAction func playButtonPressed(_ sender: UIButton) {
    actionsDelegate?.actionView(self, didAction: GuideDetailTableCellAction.playAction)
  }
  @IBAction func getButtonPressed(_ sender: UIButton) {
    actionsDelegate?.actionView(self, didAction: GuideDetailTableCellAction.getAction)
  }
  // MARK: - Animation Methods
  func setTitleText(_ titleText: String, animated: Bool = true) {
    guard trackName.text == ""
      else { trackName.text = titleText; return }
    trackName.alpha = 0.0
    trackName.text = titleText
    let duration = animated ? 0.3 : 0.0
    UIView.animate(withDuration: duration, animations: {
      self.trackName.alpha = 1.0
    })
  }
  func setTimeText(_ timeText: String, animated: Bool = true) {
    guard trackDuration.text == ""
      else { trackDuration.text = timeText; return }
    trackDuration.alpha = 0.0
    trackDuration.text = timeText
    let duration = animated ? 0.3 : 0.0
    UIView.animate(withDuration: duration, animations: {
      self.trackName.alpha = 1.0
    })
  }
  func presentDownloadButton(_ isPresent: Bool, animated: Bool = true) {
    presentView(downloadButton, isPresent: isPresent, animated: animated)
  }
  func setPlayPauseIcon(isPlaying: Bool) {
    playButton.setImage(isPlaying ? #imageLiteral(resourceName: "pauseBigButton") : #imageLiteral(resourceName: "playBigButton"), for: .normal)
  }
  func presentPlayButton(_ isPresent: Bool, animated: Bool = true) {
    presentView(playButton, isPresent: isPresent, animated: animated)
  }
  private func presentView(_ view: UIView, isPresent: Bool, animated: Bool) {
    if isPresent {
      view.isHidden = false
    }
    UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
      view.alpha = isPresent ? 1.0 : 0.0
    }, completion: { _ in
      if !isPresent {
        view.isHidden = true
      }
    })
  }
}
