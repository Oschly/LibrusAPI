//
//  CategoryColor.swift
//  LibrusAPI
//
//  Created by Oskar on 03/05/2020.
//

import Foundation

// TODO: - Implement ShortFormed
struct CategoryColor: DecodableFromNestedJSON {
  private enum CodingKeys: String, CodingKey {
    case rgb = "RGB"
  }
  
  static var codingKey: ResponseKeys = .color
  
  let id: Int?
  
  let url: URL?
  
  let rgb: String?
    
  init(from decoder: Decoder) {
    guard let shortFormedContainer = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try? shortFormedContainer.decode(Int.self, forKey: .id)
    
    if let stringUrl = try? shortFormedContainer.decode(String.self, forKey: .url) {
      self.url = URL(string: stringUrl)!
    } else {
      self.url = nil
    }
    
    guard let baseContainer = try? decoder
      .container(keyedBy: CodingKeys.self)
      else { preconditionFailure() }
    
    self.rgb = try? baseContainer.decode(String.self, forKey: .rgb)
  }
}
