//
//  MuseumTableItemDataModel.swift
//  BeaconMuseum
//
//  Created by Konstantyn on 5/1/18.
//  Copyright © 2018 Bykhkalo Konstantyn. All rights reserved.
//

import Foundation
import SDWebImage

struct MuseumTableItemDataModel {
  let title: String
  let imageUrl: String
}

extension MuseumTableItemDataModel: ViewDataModelType {
  func setup(on cell: MuseumTableCell) {
    cell.exhibitImage.sd_cancelCurrentAnimationImagesLoad()
    cell.exhibitImage.sd_setImage(with: URL(string: imageUrl), completed: nil)
    LocalizeStringService.localize(title) { (value) in
      DispatchQueue.main.async {
        cell.exhibitTitle.text = value
      }
    }
  }
}
