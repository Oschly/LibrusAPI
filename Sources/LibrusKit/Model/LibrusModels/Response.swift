//
//  Response.swift
//  LibrusKit
//
//  Created by Oskar on 03/05/2020.
//

import Foundation

public protocol NestedInJSON: Codable {
  static var codingKey: ResponseKeys { get }
}

struct Response<T: NestedInJSON>: Codable {
  let root: T
  
  public init(from decoder: Decoder) throws {
    guard let container = try? decoder.container(keyedBy: ResponseKeys.self) else { preconditionFailure() }
    self.root = try container.decode(T.self, forKey: T.codingKey)
  }
}

public enum ResponseKeys: String, CodingKey {
  case user = "User"
  
  case category = "Category"
  
  case color = "Color"
  
  case lesson = "Lesson"
  
  // "class" is a reserved keyword.
  case standardClass = "Class"
  
  case virtualClass = "VirtualClass"
  
  case school = "Unit"
  
  case subject = "Subject"
  
  case events = "HomeWorks"
}
