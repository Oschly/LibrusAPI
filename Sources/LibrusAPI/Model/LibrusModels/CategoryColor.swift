//
//  CategoryColor.swift
//  LibrusAPI
//
//  Created by Oskar on 03/05/2020.
//

import Foundation

// TODO: - Implement ShortFormed
struct CategoryColor: Codable {
  let id: Int?
  
  let url: URL?
  
  init(from decoder: Decoder) {
    guard let baseContainer = try? decoder.container(keyedBy: ShortFormedCodingKeys.self) else { preconditionFailure() }
    
    self.id = try? baseContainer.decode(Int.self, forKey: .id)
    
    if let stringUrl = try? baseContainer.decode(String.self, forKey: .url) {
      self.url = URL(string: stringUrl)!
    } else {
      self.url = nil
    }
  }
}
