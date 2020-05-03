//
//  Response.swift
//  LibrusAPI
//
//  Created by Oskar on 03/05/2020.
//

import Foundation

protocol DecodableFromNestedJSON: Codable {
  static var codingKey: ResponseKeys { get }
}

struct Response<T: DecodableFromNestedJSON>: Codable {
  let root: T
  
  init(from decoder: Decoder) throws {
    guard let container = try? decoder.container(keyedBy: ResponseKeys.self) else { preconditionFailure() }
    self.root = try! container.decode(T.self, forKey: T.codingKey)
  }
}

enum ResponseKeys: String, CodingKey {
  case user = "User"
  case category = "Category"
}
