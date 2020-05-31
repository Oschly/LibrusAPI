//
//  OnlineLesson.swift
//  LibrusKit
//
//  Created by Oskar on 30/05/2020.
//

import Foundation

public struct LKOnlineLesson: Codable {
  private enum CodingKeys: String, CodingKey {
    case url
    case text = "text"
  }
  
  let url: URL
  let text: String
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let urlString = try container.decode(String.self, forKey: .url)
    self.url = URL(string: urlString)!
    self.text = try container.decode(String.self, forKey: .text)
  }
}
