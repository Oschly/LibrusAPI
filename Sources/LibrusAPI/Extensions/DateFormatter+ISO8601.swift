//
//  DateFormatter+ISO8601.swift
//  ddd
//
//  Created by Oskar on 05/05/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation

extension DateFormatter {
  static let ISO8601WithTime: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return formatter
  }()
  
  static let ISO8601WithoutTime: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    return formatter
  }()
}
