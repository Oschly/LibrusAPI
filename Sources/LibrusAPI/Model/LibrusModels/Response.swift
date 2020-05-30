//
//  Response.swift
//  LibrusAPI
//
//  Created by Oskar on 03/05/2020.
//

import Foundation

public protocol DecodableFromNestedJSON: Codable {
  static var codingKey: ResponseKeys { get }
}

public struct Response<T: DecodableFromNestedJSON>: Codable {
  let root: T
  
  public init(from decoder: Decoder) throws {
    guard let container = try? decoder.container(keyedBy: ResponseKeys.self) else { preconditionFailure() }
    self.root = try! container.decode(T.self, forKey: T.codingKey)
  }
}

public enum ResponseKeys: String, CodingKey {
  case user = "User"
  
  case category = "Category"
  
  case color = "Color"
  
  case lesson = "Lesson"
  
  // "class" is a reserved keyword.
  case classGroup = "Class"
  
  case school = "Unit"
  
  case subject = "Subject"
  
  case events = "HomeWorks"
}
