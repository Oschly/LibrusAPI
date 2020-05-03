//
//  User.swift
//  ddd
//
//  Created by Oskar on 27/04/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation

protocol User: Codable {
  var id: Int? { get }
  
  var accountId: String? { get }
  
  var firstName: String? { get }
  
  var lastName: String? { get }
}

enum UserCodingKeys: String, CodingKey {
  case id = "Id"
  case accountId = "AccountId"
  case firstName = "FirstName"
  case lastName = "LastName"
}

//struct BaseUser: Codable {
//  let id: Int
//  
//  let accountId: String
//  
//  let firstName: String
//  
//  let lastName: String
//  
//  init(from decoder: Decoder) {
//    guard let container = try? decoder
//      .container(keyedBy: UserCodingKeys.self)
//      else { preconditionFailure() }
//    
//    self.accountId = try! container.decode(String.self, forKey: .accountId)
//    self.firstName = try! container.decode(String.self, forKey: .firstName)
//    self.lastName = try! container.decode(String.self, forKey: .lastName)
//    self.id = try! container.decode(Int.self, forKey: .id)
//  }
//  
//  init(id: Int, accountId: String, firstName: String, lastName: String) {
//    self.id = id
//    self.accountId = accountId
//    self.firstName = firstName
//    self.lastName = lastName
//  }
//}
