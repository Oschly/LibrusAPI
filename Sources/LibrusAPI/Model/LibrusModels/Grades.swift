//
//  Grades.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

struct Grades: Codable {
  let grades: [Grade]
  
  enum CodingKeys: String, CodingKey {
    case grades = "Grades"
  }
}
