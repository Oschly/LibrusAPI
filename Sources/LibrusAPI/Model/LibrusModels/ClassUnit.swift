//
//  ClassUnit.swift
//  ddd
//
//  Created by Oskar on 05/05/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation

struct ClassUnit: ShortFormed {
  var id: Int?
  
  var url: URL?
  
  init(from decoder: Decoder) {
    guard let shortFormedContainer = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try? shortFormedContainer.decode(Int.self, forKey: .id)
    
    if let stringUrl = try? shortFormedContainer.decode(String.self, forKey: .url) {
      self.url = URL(string: stringUrl)!
    }
  }
}

extension ClassUnit: DecodableFromNestedJSON {
  static var codingKey: ResponseKeys = .classUnit
}
