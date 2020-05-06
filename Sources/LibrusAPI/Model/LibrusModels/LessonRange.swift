//
//  LessonRange.swift
//  LibrusAPI
//
//  Created by Oskar on 06/05/2020.
//

import Foundation

public struct LessonsRange: Codable {
  private enum CodingKeys: String, CodingKey {
    case rawStart = "RawFrom"
    case rawEnd = "RawTo"
  }
  
  /// Defined as minutes from midnight
  let rawStart: Int
  
  /// Defined as minutes from midnight
  let rawEnd: Int
  
  let start: String
  let end: String
  
  public init(from decoder: Decoder) {
    guard let container = try? decoder
      .container(keyedBy: CodingKeys.self)
      else { preconditionFailure() }
    
    self.rawStart = try! container.decode(Int.self, forKey: .rawStart)
    self.rawEnd = try! container.decode(Int.self, forKey: .rawEnd)
    
    self.start = rawStart.toHourString()
    self.end = rawEnd.toHourString()
  }
}
