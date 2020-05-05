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
