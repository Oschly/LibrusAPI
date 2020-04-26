//
//  Semester.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

enum Semester: Int, Codable {
  case first = 1
  case second = 2
}

extension Semester: CustomStringConvertible {
  var description: String {
    switch self {
    case .first:
      return "first"
    case .second:
      return "second"
    }
  }
}
