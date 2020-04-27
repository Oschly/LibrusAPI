//
//  User.swift
//  ddd
//
//  Created by Oskar on 27/04/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation

struct User: Codable {
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case accountId = "AccountId"
    case firstName = "FirstName"
    case lastName = "LastName"
  }
  
  let id: Int
  
  let accountId: String
  
  let firstName: String
  
  let lastName: String
      
  init(from decoder: Decoder) {
    guard let container = try? decoder
      .container(keyedBy: CodingKeys.self)
      else { preconditionFailure() }
    
    self.accountId = try! container.decode(String.self, forKey: .accountId)
    self.firstName = try! container.decode(String.self, forKey: .firstName)
    self.lastName = try! container.decode(String.self, forKey: .lastName)
    self.id = try! container.decode(Int.self, forKey: .id)
  }
}
