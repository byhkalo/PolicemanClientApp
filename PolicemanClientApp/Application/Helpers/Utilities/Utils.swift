//
//  Utils.swift
//
//

import Foundation
import UIKit
import SystemConfiguration

func base64StringFromImage(_ image: UIImage) -> String {
  var data: Data = Data()
  data = image.jpegData(compressionQuality: 0.1)!
  let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
  return base64String
}

//Validator
func stringIsValidEmail(_ checkString: String) -> Bool {
  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
  let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
  return emailTest.evaluate(with: checkString)
}
func isConnectedToNetwork() -> Bool {
  var zeroAddress = sockaddr_in()
  zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
  zeroAddress.sin_family = sa_family_t(AF_INET)
  let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
    $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
      SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
    }
  }
  var flags = SCNetworkReachabilityFlags()
  if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
    return false
  }
  let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
  let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
  return (isReachable && !needsConnection)
}

func delay(_ delay: Double, closure: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(
    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
struct Bridge {
  // MARK: - Bridge Instruments
  static func bridge<T: AnyObject>(obj: T) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
  }
  static func bridge<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
  }
  static func bridgeRetained<T: AnyObject>(obj: T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
  }
  static func bridgeTransfer<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
  }
}

struct Converter {
  // MARK: - Make String From Date Converter
  static func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    let dateString = dateFormatter.string(from: date)
    return dateString
  }
  static func daySringFromDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
  }
  static func sringFromDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return dateFormatter.string(from: date)
  }
  static func prettySringFromDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy MMM dd"
    return dateFormatter.string(from: date)
  }
  static func fullHoursInDate(_ date: Date) -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H"
    return Int(dateFormatter.string(from: date))
  }
  // MARK: - Make Date From String Converter
  static func dateFromString(_ string: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter.date(from: string)
  }
  static func dateFromDayString(_ string: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: string)
  }
  static func dateWithParams(_ hours: Int, minutes: Int, seconds: Int, byDay: Date) -> Date? {
    var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    calendar.timeZone = (TimeZone.autoupdatingCurrent)
    let unitFlags: NSCalendar.Unit = [.day, .month, .year]
    var dateComponents = (calendar as NSCalendar?)?.components(unitFlags, from: Date())
    dateComponents?.hour = hours
    dateComponents?.minute = minutes
    dateComponents?.second = seconds
    //return date relative from date
    return calendar.date(from: dateComponents!)
  }
  // MARK: Date Operations
  static func dayDelta(dateOne: Date, dateTwo: Date) -> Int {
    let dateOneConv = dateFromDayString(daySringFromDate(dateOne))
    let dateTwoConv = dateFromDayString(daySringFromDate(dateTwo))
    var deltaTimeStamp: Double = Double(dateOneConv!.timeIntervalSinceReferenceDate - dateTwoConv!.timeIntervalSinceReferenceDate)
    deltaTimeStamp = deltaTimeStamp < 0 ? deltaTimeStamp * -1 : deltaTimeStamp
    let dayDelta = Int(deltaTimeStamp / 60 / 60 / 24)
    return dayDelta
  }
  // MARK: - Height Converter
  static func convertToHeightUsingFeet(_ feet: Int, inches: Int) -> Int {
    return (feet * 12 + inches)
  }
  static func convertToFeetInchUseHeight(_ height: Int) -> (feet: Int, inches: Int) {
    if height > 0 {
      let feet = Int(height / 12)
      let inches = height % 12
      return (feet, inches)
    }
    return (0, 0)
  }
}
