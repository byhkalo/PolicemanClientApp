//
//  CGFloat+Extension.swift
//
//

import Foundation
import UIKit

extension CGFloat {
  func toRadians() -> CGFloat {
    return self * CGFloat(Double.pi) / CGFloat(180)
  }
  func toDegrees() -> CGFloat {
    return self * CGFloat(180) / CGFloat(Double.pi)
  }
}

protocol CGFloatProtocol {
  var cgFloat: CGFloat {get}
}

extension CGFloatProtocol {
  func toRadians() -> CGFloat {
    return self.cgFloat.toRadians()
  }
  func toDegrees() -> CGFloat {
    return self.cgFloat.toDegrees()
  }
}

extension Int: CGFloatProtocol {
  internal var cgFloat: CGFloat {
    return CGFloat(self)
  }
}

extension Float: CGFloatProtocol {
  var cgFloat: CGFloat {
    return CGFloat(self)
  }
}
