//
//  AccessToken.swift
//  LibrusAPI
//
//  Created by Oskar on 16/04/2020.
//

import Foundation

struct AccessToken: Decodable {
  let type: String
  let expiration: Date
  let token: String
  let refreshToken: String
  
  enum CodingKeys: String, CodingKey {
    case type = "token_type"
    case expiresIn = "expires_in"
    case token = "access_token"
    case refreshToken = "refresh_token"
  }
  
  init(from decoder: Decoder) throws {
    guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { preconditionFailure() }
    
    self.type = try container.decode(String.self, forKey: .type)
    self.token = try container.decode(String.self, forKey: .token)
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    
    let expireTime = try container.decode(Double.self, forKey: .expiresIn)
    self.expiration = Date().addingTimeInterval(expireTime)
  }
}
