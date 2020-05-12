//
//  CategoryColor.swift
//  LibrusAPI
//
//  Created by Oskar on 03/05/2020.
//

import Foundation

public struct CategoryColor: DecodableFromNestedJSON {
  private enum CodingKeys: String, CodingKey {
    case rgb = "RGB"
  }
  
  public static var codingKey: ResponseKeys = .color
  
  public let id: Int?
  
  public let url: URL?
  
  public let rgb: String?
    
  public init(from decoder: Decoder) {
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
