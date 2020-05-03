//
//  Lesson.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

struct Lesson: Codable, ShortFormed {
  let id: Int?
  
  let url: URL?
  
  init(from decoder: Decoder) {
    guard let container = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try! container.decode(Int.self, forKey: .id)
    self.url = URL(string: try! container.decode(String.self, forKey: .url))!
  }
  
  func fetchedInfo(token: String) -> Lesson {
    // TODO: Implement that
    return self
  }
}
