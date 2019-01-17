//
//  TimeInterval+Extension.swift
//
//

import Foundation

// MARK: Time
extension TimeInterval {
  struct DateComponents {
    static let formatterPositional: DateComponentsFormatter = {
      let formatter = DateComponentsFormatter()
      formatter.allowedUnits = [.minute, .second]
      formatter.unitsStyle = .positional
      formatter.zeroFormattingBehavior = .pad
      return formatter
    }()
  }
  var positionalTime: String {
    return DateComponents.formatterPositional.string(from: self) ?? ""
  }
}

extension TimeInterval {
  var minuteSecondMS: String {
    return String(format: "%d:%02d.%03d", minute, second, millisecond)
  }
  var minute: Int {
    return Int((self/60).truncatingRemainder(dividingBy: 60))
  }
  var second: Int {
    return Int(truncatingRemainder(dividingBy: 60))
  }
  var millisecond: Int {
    return Int((self*1000).truncatingRemainder(dividingBy: 1000))
  }
}
