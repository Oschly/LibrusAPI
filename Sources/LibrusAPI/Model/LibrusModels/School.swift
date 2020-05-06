//
//  School.swift
//  ddd
//
//  Created by Oskar on 05/05/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation

struct School: ShortFormed {
  private enum CodingKeys: String, CodingKey {
    case name = "Name"
    case shortName = "ShortName"
    case type = "Type"
    case lessonsRange = "LessonsRange"
  }
  
  let id: Int?
  
  let url: URL?
  
  let name: String?
  
  let shortName: String?
  
  let type: String?
  
  let lessonsRange: [LessonsRange]?
  
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
    
    self.name = try? baseContainer.decode(String.self, forKey: .name)
    self.shortName = try? baseContainer.decode(String.self, forKey: .shortName)
    self.type = try? baseContainer.decode(String.self, forKey: .type)
    self.lessonsRange = try? baseContainer.decode([LessonsRange].self, forKey: .lessonsRange)
  }
}

extension School: DecodableFromNestedJSON {
  static var codingKey: ResponseKeys = .school
}
