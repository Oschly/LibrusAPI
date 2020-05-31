//
//  Int+FormatToHour.swift
//  LibrusKit
//
//  Created by Oskar on 06/05/2020.
//

import Foundation

extension Int {
  func toHourString() -> String {
    let hour = self / 60
    let minutes = self % 60
    
    return "\(hour):\(minutes)"
  }
}
