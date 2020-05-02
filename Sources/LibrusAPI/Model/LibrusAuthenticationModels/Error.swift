//
//  Error.swift
//  ddd
//
//  Created by Oskar on 02/05/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation

struct ErrorJSON: Codable {
  let status: JSONErrorStatus
  let message: String
  let code: ErrorCode
  
  enum CodingKeys: String, CodingKey {
    case status = "Status"
    case message = "Message"
    case code = "Code"
  }
}

enum JSONErrorStatus: String, Codable {
  case error = "Error"
}

enum ErrorCode: String, Codable {
  case tokenExpired = "TokenIsExpired"
}
