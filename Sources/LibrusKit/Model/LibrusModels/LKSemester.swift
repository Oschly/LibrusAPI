//
//  LKSemester.swift
//  LibrusKit
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public enum LKSemester: Int, Codable {
  case first = 1
  case second = 2
}

extension LKSemester: CustomStringConvertible {
  public var description: String {
    switch self {
    case .first:
      return "first"
    case .second:
      return "second"
    }
  }
}
