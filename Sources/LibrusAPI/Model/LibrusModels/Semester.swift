//
//  Semester.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public enum Semester: Int, Codable {
  case first = 1
  case second = 2
}

extension Semester: CustomStringConvertible {
  public var description: String {
    switch self {
    case .first:
      return "first"
    case .second:
      return "second"
    }
  }
}
