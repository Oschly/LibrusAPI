//
//  Grades.swift
//  LibrusKit
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public struct Grades: Codable {
  public let grades: [Grade]
  
  enum CodingKeys: String, CodingKey {
    case grades = "Grades"
  }
}
