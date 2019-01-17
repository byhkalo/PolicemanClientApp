//
//  Constants.swift
//
//

import UIKit

struct Constants {
  static let UUID = "uuid"
  static let Museum = "museum"
  static let Exhibits = "exhibits"
  static let Guides = "guides"
  static let Beacons = "beacons"
  static let Users = "users"
  struct MuseumProperties {
    static let Name = "musName"
    static let TrackUrl = "musTrack"
    static let ImageUrl = "musImage"
    static let GuideModels = "guideModels" // Not for Firebase
    static let UUID = "uuid" // Not for Firebase
  }
  struct GuideProperties {
    static let Identifier = "identifier"
    static let GuideName = "guiName"
    static let GuideDescription = "guiDescription"
    static let Rates = "rates"
    static let ImageUrl = "imageUrl"
    static let ExhibitIDs = "exhibitIDs"
    //
    static let ExhibitModels = "exhibitModels" // Not for Firebase
    static let GuideImage = "guideImage" // Not for Firebase
  }
  struct ExhibitProperties {
    static let Identifier = "identifier"
    static let Number = "number"
    static let ExhibitName = "name"
    static let ExhibitDescription = "localisedDescription"
    static let BeaconId = "beaconID"
    static let Distance = "distance"
    static let TrackUrl = "trackUrl"
    static let ImageUrl = "imageUrl"
    static let ImageSetUrls = "imageSetUrls"
    static let BeaconModel = "beaconModel" // Not for Firebase
    static let TrackName = "trackName" // Not for Firebase
    static let ExhibitImage = "exhibitImage" // Not for Firebase
    static let ExhibitImageSet = "exhibitImageSet" // Not for Firebase
  }
  struct BeaconProperties {
    static let Identifier = "identifier"
    static let Name = "beName"
    static let BeaconDescription = "beDescription"
    static let UUID = "beUUID"
    static let Major = "major"
    static let Minor = "minor"
    static let Level = "level"
  }
  struct UserProperties {
    static let UserID = "userId"
    static let Email = "email"
  }
  struct Images {
    static let rateImg = "Star 2rate"
    static let unrateImg = "Star 2rate2"
    static let rateImgSmall = "Star"
    static let unrateImgSmall = "Star2"
    static let pauseButton = "pauseButton"
    static let playButton = "playButton"
    static let pauseBigButton = "pauseBigButton"
    static let playBigButton = "playBigButton"
  }
}

struct Images {
  static let rateImg = UIImage(named: Constants.Images.rateImg)
  static let unrateImg = UIImage(named: Constants.Images.unrateImg)
  static let rateImgSmall = UIImage(named: Constants.Images.rateImgSmall)
  static let unrateImgSmall = UIImage(named: Constants.Images.unrateImgSmall)
  static let pause = UIImage(named: Constants.Images.pauseButton)
  static let play = UIImage(named: Constants.Images.playButton)
}

typealias TxGn = Text.General

struct Text {
  struct General {
    static let error = "Error".localized
    static let sorry = "Sorry".localized
    static let cant = "Can't".localized
    static let pleaseTryLater = "Please_try_later".localized
    static let pleaseCheckInternet = "Please check Internet connection"
    static let save = "save".localized
    static let get = "get".localized
    static let write = "write".localized
    static let toStorage = "to storage".localized
    static let fromServer = "from server".localized
    static let image = "image".localized
    static let sound = "sound".localized
    ///Alerts
    static let OK = "OK".localized
    static let Info = "Info".localized
    static let Story = "Story_loc".localized
    static let RateNow = "Rate Now_loc".localized
    static let Share = "Share_loc".localized
    ///Vote
    static let Rate = "Rate_loc".localized
    static let oneVote = "vote".localized
    static let manyVotes = "votes".localized
    static let RateIt = "Rate it_loc".localized
    ///Guide Detail Content
    static let Download = "DOWNLOAD_loc".localized
    static let theEntireStory = "the entire story_loc".localized
    static let ScanItem = "SCAN ITEM_loc".localized
    static let orEnterIdCode = "or enter id code_loc".localized
    ///Bluetooth Alert
    static let bluetoothIsDisabled = "Bluetooth is Disabled".localized
    static let forUsingHandlessMode = "For using Handless Mode".localized
    ///DETAILED: "For using Handless Mode, plese enable bluetooth. Press Ok for opening System Bluetooth settigns."
    static let handlessModeExit = "Handless Mode Exit".localized
    static let handlessModeDissappeared = "Handless Mode will be dissappeared".localized
    ///Request Access Alert
    static let access = "Access".localized
    static let handlessModeAccess = "Handless Mode Access".localized
    static let pleasePressOk = "Please, press Ok".localized
    ///DETAILED: "Please, press Ok button for openning settings and activate permission for use."
    static let pleaseInTheNextWindow = "Please, in the next window".localized
    ///DETAILED: "Please, in the next window activate location for usin awersome handless mode."
    static let dontWorry = "Don't worry".localized
    static let youAllwaysCanEnableFromSeingAndApp = "You can enable From Setting And App".localized
    ///DEATILED: "You allways can eneble This mode From System Settings or Application Setting screen"
    static let youAllwaysCanEnableFromSetting = "You can enable From setting screen".localized
    ///DETAILED: "You allways can enable this mode from setting screen"
    ///Accessary Buttons
    static let Done = "Done".localized
    static let Cancel = "Cancel".localized
    ///QR Codes
    static let Code = "Code_loc".localized
    static let noQRCode = "No QR code is detected".localized
    static let cantFindCode = "Can't find Code ".localized
    ///Info View
    static let info = "info_loc".localized
    static let showLess = "SHOW LESS".localized
    static var readMore: String { return "READ MORE".localized }
    static let Hide = "HIDE_loc".localized
  }
  static let beaconAlertInfo = "".localized
}
