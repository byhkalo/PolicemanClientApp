//
//  GuideDetailTableItemDataModel.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 5/3/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation

struct GuideDetailTableItemDataModel {
  let name: String
  let number: String
  let duration: String
  let isDownloading: Bool
  let isPlaying: Bool
}

extension GuideDetailTableItemDataModel: ViewDataModelType {
  func setup(on cell: GuideDetailTableCell) {
    cell.spinner.isHidden = !isDownloading
    cell.downloadButton.isHidden = (isDownloading)
    cell.playButton.isHidden = (isDownloading)
    cell.trackNumber.text = number
    LocalizeStringService.localize(name) { (value) in
      DispatchQueue.main.async {
        cell.setTitleText(value)
      }
    }
    cell.setPlayPauseIcon(isPlaying: isPlaying)
    if isDownloading {
      cell.spinner.startAnimating()
    } else {
      cell.spinner.stopAnimating()
    }
  }
}
