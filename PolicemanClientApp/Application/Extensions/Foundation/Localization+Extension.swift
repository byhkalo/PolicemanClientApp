//
//  Localization+Extension.swift
//
//

import Foundation
import UIKit
// MARK: - LocalizationExtensions
open class LocalizationExtensions {
  // Static Properties
  public static var lang: String {
    return SettingAppManager.shared.applicationLanguage
  }
  public static let notificationMissingTransalation = "LocalizationExtensions.missingTranslation"
  public static func addBundle(_ bundle: Bundle) {
    guard !bundles.contains(bundle), bundle != Bundle.main
      else { return }
    bundles.append(bundle)
  }
  // Private Static Properties
  fileprivate static var bundles: [Bundle] = []
}
// MARK: - String Extension
extension String {
  public var localized: String {
    return self.localizedWithComment("")
  }
  public func localizedWithComment(_ comment: String) -> String {
    let lang = LocalizationExtensions.lang
    if let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
      let bundle = Bundle(path: path),
      let string = localizedWithComment(comment, bundle: bundle, recursion: 1) {
      return string
    }
    if let string = localizedWithComment(comment, bundle: Bundle.main, recursion: 1) {
      return string
    }
    if let string = localizedWithComment(comment, bundles: LocalizationExtensions.bundles) {
      return string
    }
    print("Missed Localization for Text: - \"\(self)\"")
    NotificationCenter.default.post(name: Notification.Name(rawValue: LocalizationExtensions.notificationMissingTransalation), object: self)
    return self
  }
  fileprivate func localizedWithComment(_ comment: String,
                                        bundles: [Bundle]) -> String? {
    for bundle in bundles where bundle != Bundle.main {
      if let string = self.localizedWithComment(comment, bundle: bundle, recursion: 1) {
        return string
      }
    }
    return nil
  }
  fileprivate func localizedWithComment(_ comment: String, bundle: Bundle,
                                        recursion: Int) -> String? {
    let string = NSLocalizedString(self, tableName: nil, bundle: bundle,
                                   value: "", comment: comment)
    if self != string {
      return string
    }
    if recursion > 0 {
      if let urls = bundle.urls(forResourcesWithExtension: "bundle", subdirectory: nil) {
        for subURL in urls {
          if let subBundle = Bundle(url: subURL) {
            if let subString = self.localizedWithComment(
              comment, bundle: subBundle, recursion: recursion - 1) {
              return subString
            }
          }
        }
      }
    }
    return nil
  }
  /*
   var localized: String {
   if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
   // we set a default, just in case
   UserDefaults.standard.set("fr", forKey: "i18n_language")
   UserDefaults.standard.synchronize()
   }
   
   let lang = UserDefaults.standard.string(forKey: "i18n_language")
   
   let path = Bundle.main.path(forResource: lang, ofType: "lproj")
   let bundle = Bundle(path: path!)
   
   return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
   }
   */
}
// MARK: - UILabel Extension
extension UILabel {
  @IBInspectable public var lzText: String? {
    set {
      guard newValue != nil else { text = nil; return }
      text = newValue?.localized
    }
    get { return text }
  }
}
// MARK: - UITextField Extension
extension UITextField {
  // Text
  @IBInspectable public var lzText: String? {
    set {
      guard newValue != nil else { text = nil; return }
      text = newValue?.localized
    }
    get { return text }
  }
  // Placeholder
  @IBInspectable public var lzPlaceholder: String? {
    set {
      guard newValue != nil else { placeholder = nil; return }
      placeholder = newValue?.localized
    }
    get { return placeholder }
  }
}

extension UIButton {
  @IBInspectable public var lzTitle: String? {
    set { setLocalizedTitle(newValue, state: UIControl.State.normal) }
    get { return getTitleForState(UIControl.State.normal) }
  }
  @IBInspectable public var lzTitleHighlighted: String? {
    set { setLocalizedTitle(newValue, state: UIControl.State.highlighted) }
    get { return getTitleForState(UIControl.State.highlighted) }
  }
  @IBInspectable public var lzTitleDisabled: String? {
    set { setLocalizedTitle(newValue, state: UIControl.State.disabled) }
    get { return getTitleForState(UIControl.State.disabled) }
  }
  @IBInspectable public var lzTitleSelected: String? {
    set { setLocalizedTitle(newValue, state: UIControl.State.selected) }
    get { return getTitleForState(UIControl.State.selected) }
  }
  @IBInspectable public var lzTitleFocused: String? {
    set { setLocalizedTitle(newValue, state: UIControl.State.focused) }
    get { return getTitleForState(UIControl.State.focused) }
  }
  @IBInspectable public var lzTitleApplication: String? {
    set { setLocalizedTitle(newValue, state: UIControl.State.application) }
    get { return getTitleForState(UIControl.State.application) }
  }
  @IBInspectable public var lzTitleReserved: String? {
    set { setLocalizedTitle(newValue, state: UIControl.State.reserved) }
    get { return getTitleForState(UIControl.State.reserved) }
  }
  fileprivate func setLocalizedTitle(_ title: String?, state: UIControl.State) {
    if let title = title {
      setTitle(title.localized, for: state)
    } else {
      setTitle(nil, for: state)
    }
  }
  fileprivate func getTitleForState(_ state: UIControl.State) -> String? {
    guard let title = titleLabel else { return nil }
    return title.text
  }
}
// MARK: - UIBarItem Extension
extension UIBarItem {
  @IBInspectable public var lzTitle: String? {
    set {
      guard newValue != nil else { title = nil; return }
      title = newValue?.localized
    }
    get { return title }
  }
}
// MARK: - UINavigationItem Extension
extension UINavigationItem {
  @IBInspectable public var lzTitle: String? {
    set {
      guard newValue != nil else { title = nil; return }
      title = newValue?.localized
    }
    get { return title }
  }
  @IBInspectable public var lzPrompt: String? {
    set {
      guard newValue != nil else { prompt = nil; return }
      prompt = newValue?.localized
    }
    get { return prompt }
  }
}
// MARK: - UIViewController Extension
extension UIViewController {
  @IBInspectable public var lzTitle: String? {
    set {
      guard newValue != nil else { title = nil; return }
      title = newValue?.localized
    }
    get { return title }
  }
}
