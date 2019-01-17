//
//  String+Extension.swift
//
//

//: # Swift 3: Base64 encoding and decoding
//: get from https://gist.github.com/stinger/a8a0381a57b4ac530dd029458273f31a
import Foundation
import UIKit

extension String {
  //: ### Base64 encoding a string
  func base64Encoded() -> String? {
    if let data = self.data(using: .utf8) {
      return data.base64EncodedString()
    }
    return nil
  }
  //: ### Base64 decoding a string
  func base64Decoded() -> String? {
    if let data = Data(base64Encoded: self) {
      return String(data: data, encoding: .utf8)
    }
    return nil
  }
}

extension String.Index {
  func successor(in string: String) -> String.Index {
    return string.index(after: self)
  }
  func predecessor(in string: String) -> String.Index {
    return string.index(before: self)
  }
  func advance(_ offset: Int, `for` string: String) -> String.Index {
    return string.index(self, offsetBy: offset)
  }
}

extension String {
  func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(
      with: constraintRect, options: .usesLineFragmentOrigin,
      attributes: [NSAttributedString.Key.font: font], context: nil)
    return ceil(boundingBox.height)
  }
  func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(
      with: constraintRect, options: .usesLineFragmentOrigin,
      attributes: [NSAttributedString.Key.font: font], context: nil)
    return ceil(boundingBox.width)
  }
}
