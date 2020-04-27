//
//  Teacher.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

struct Teacher: Codable {
  enum CodingKeys: String, CodingKey {
    case info = "User"
  }
  
  private(set) var info: User? = nil
  
  private(set) var id: Int?
  
  private(set) var url: URL?
  
  init(from decoder: Decoder) {
    guard let shortFormedContainer = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    if let id = try? shortFormedContainer.decode(Int.self, forKey: .id) {
      self.id = id
    }
    
    if let stringUrl = try? shortFormedContainer.decode(String.self, forKey: .url) {
      self.url = URL(string: stringUrl)!
    }
    
    guard let defaultContainer = try? decoder
      .container(keyedBy: CodingKeys.self)
      else { return }
    
    if let info = try? defaultContainer.decode(User.self, forKey: .info) {
      self.info = info
      self.id = info.id
    }
  }
}
