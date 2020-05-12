//
//  AccessList.swift
//  LibrusAPI
//
//  Created by Oskar on 20/04/2020.
//

import Foundation

public struct AccessList: Codable {
  public struct SynergiaAccount: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
      case id
      case group
      case token = "accessToken"
      case login
      case name = "studentName"
      case scopes
      case state
    }
    
    public enum AccountGroup: String {
      case student, parent
    }
    
    public enum AccountState: String {
      case active
    }
    
    public let id: Int
    public let group: AccountGroup
    public let token: String
    public let login: String
    public let name: String
    public let scopes: String
    public let state: AccountState
    
    public init(from decoder: Decoder) throws {
      guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { preconditionFailure() }
      let groupRaw = try! container.decode(String.self, forKey: .group)
      self.group = AccountGroup(rawValue: groupRaw)!
      
      self.id = try! container.decode(Int.self, forKey: .id)
      self.token = try! container.decode(String.self, forKey: .token)
      self.login = try! container.decode(String.self, forKey: .login)
      self.name = try! container.decode(String.self, forKey: .name)
      self.scopes = try! container.decode(String.self, forKey: .scopes)
      
      let stateRaw = try! container.decode(String.self, forKey: .state)
      self.state = AccountState(rawValue: stateRaw)!
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      
      try! container.encode(id, forKey: .id)
      try! container.encode(group.rawValue, forKey: .group)
      try! container.encode(token, forKey: .token)
      try! container.encode(login, forKey: .login)
      try! container.encode(name, forKey: .name)
      try! container.encode(scopes, forKey: .scopes)
      try! container.encode(state.rawValue, forKey: .state)
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case lastModified = "lastModification"
    case accounts
  }
  
  public let lastModified: Int
  public let accounts: [SynergiaAccount]
  
  
  
  public init(from decoder: Decoder) throws {
    guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { preconditionFailure() }
    self.lastModified = try! container.decode(Int.self, forKey: .lastModified)
    self.accounts = try! container.decode([SynergiaAccount].self, forKey: .accounts)
  }
}
