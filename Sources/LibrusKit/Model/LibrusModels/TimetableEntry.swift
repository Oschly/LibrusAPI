//
//  TimetableEntry.swift
//  LibrusKit
//
//  Created by Oskar on 18/06/2020.
//

import Foundation

public struct TimetableEntry: ShortFormed, NestedInJSON {
  public static var codingKey: ResponseKeys = .user // Temporary
  
  public let id: Int?
  public let url: URL?
  
  public init(from decoder: Decoder) throws {
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
