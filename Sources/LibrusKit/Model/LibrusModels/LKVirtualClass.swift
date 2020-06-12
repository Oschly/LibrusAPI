//
//  LKVirtualClass.swift
//  LibrusKit
//
//  Created by Oskar on 30/05/2020.
//

import Foundation

public struct LKVirtualClass: ShortFormed, NestedInJSON {
  public static var codingKey: ResponseKeys = .virtualClass
  
  private(set) public var id: Int?
  
  private(set) public var url: URL?
  
  public init(from decoder: Decoder) {
    guard let shortFormedContainer = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try? shortFormedContainer.decode(Int.self, forKey: .id)
    
    if let urlString = try? shortFormedContainer.decode(String.self, forKey: .url) {
      self.url = URL(string: urlString)
    } else {
      self.url = nil
    }
  }
}
