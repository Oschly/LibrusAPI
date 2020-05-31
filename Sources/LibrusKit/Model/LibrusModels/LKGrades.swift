//
//  LKGrades.swift
//  LibrusKit
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public struct LKGrades: Codable {
  public let grades: [LKGrade]
  
  enum CodingKeys: String, CodingKey {
    case grades = "Grades"
  }
}
