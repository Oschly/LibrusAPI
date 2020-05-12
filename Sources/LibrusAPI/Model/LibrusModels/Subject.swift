//
//  Subject.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public struct Subject: Codable, ShortFormed {
  private enum CodingKeys: String, CodingKey {
    case name = "Name"
    case isExtracurricular = "IsExtraCurricular"
    case isBlockLesson = "IsBlockLesson"
  }
  
  public let id: Int?
  
  public let url: URL?
  
  public let name: String?
  
  public let isExtracurricular: Bool?
  
  public let isBlockLesson: Bool?
  
  public init(from decoder: Decoder) {
    guard let shortFormed = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try? shortFormed.decode(Int.self, forKey: .id)
    
    if let urlString = try? shortFormed.decode(String.self, forKey: .url) {
      self.url = URL(string: urlString)!
    } else {
      self.url = nil
    }
    
    guard let baseContainer = try? decoder
      .container(keyedBy: CodingKeys.self)
      else { preconditionFailure() }
    
    self.name = try? baseContainer.decode(String.self, forKey: .name)
    self.isExtracurricular = try? baseContainer.decode(Bool.self, forKey: .isExtracurricular)
    self.isBlockLesson = try? baseContainer.decode(Bool.self, forKey: .isBlockLesson)
  }
}

extension Subject: DecodableFromNestedJSON {
  public static var codingKey: ResponseKeys = .subject
}
