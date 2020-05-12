//
//  Student.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public struct Student: DecodableFromNestedJSON, ShortFormed {
  public static var codingKey: ResponseKeys = .user
  
  public let id: Int?
  
  public let url: URL?
  
 public init(from decoder: Decoder) {
    guard let container = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try! container.decode(Int.self, forKey: .id)
    self.url = URL(string: try! container.decode(String.self, forKey: .url))!
  }
}
