//
//  Teacher.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

struct Teacher: ShortFormed, User {
  private enum CodingKeys: String, CodingKey {
    case accountId = "AccountId"
    case firstName = "FirstName"
    case lastName = "LastName"
  }
  
  private(set) var accountId: String? = nil
  
  private(set) var firstName: String? = nil
  
  private(set) var lastName: String? = nil
  
  private(set) var id: Int?
  
  private(set) var url: URL?
  
  init(from decoder: Decoder) {
    guard let shortFormedContainer = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try? shortFormedContainer.decode(Int.self, forKey: .id)
    
    if let stringUrl = try? shortFormedContainer.decode(String.self, forKey: .url) {
      self.url = URL(string: stringUrl)!
    }
    
    guard let localContainer = try? decoder
      .container(keyedBy: CodingKeys.self)
      else { preconditionFailure() }
    
    self.firstName = try? localContainer.decode(String.self, forKey: .firstName)
    self.lastName = try? localContainer.decode(String.self, forKey: .lastName)
    self.accountId = try? localContainer.decode(String.self, forKey: .accountId)
  }
  
  // Initialiser for `fetchedInfo(token:)` method.
  init(accountId: String?, firstName: String?, lastName: String?, id: Int?, url: URL?) {
    self.accountId = accountId
    self.firstName = firstName
    self.lastName = lastName
    self.id = id
    self.url = url
  }
}

extension Teacher: DecodableFromNestedJSON {
  static var codingKey: ResponseKeys = .user
}
