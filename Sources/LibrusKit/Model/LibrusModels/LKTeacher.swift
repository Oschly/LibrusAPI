//
//  LKTeacher.swift
//  LibrusKit
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public struct LKTeacher: ShortFormed, User {
  private enum CodingKeys: String, CodingKey {
    case accountId = "AccountId"
    case firstName = "FirstName"
    case lastName = "LastName"
  }
  
  private(set) public var accountId: String? = nil
  
  private(set) public var firstName: String? = nil
  
  private(set) public var lastName: String? = nil
  
  private(set) public var id: Int?
  
  private(set) public var url: URL?
  
  public init(from decoder: Decoder) {
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
}

extension LKTeacher: DecodableFromNestedJSON {
  public static var codingKey: ResponseKeys = .user
}
