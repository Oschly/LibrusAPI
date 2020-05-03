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
    
    if let id = try? shortFormedContainer.decode(Int.self, forKey: .id) {
      self.id = id
    }
    
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
  
  /// Has to be executed on background thread, otherwise semaphore in method will freeze main thread.
  /// - Parameter token: Used to acquire Teacher's data
  /// - Returns: If method didn't failed to fetch data, it will return filled `Teacher` object.
}

extension Teacher: DecodableFromNestedJSON {
  static var codingKey: ResponseKeys = .user
}
