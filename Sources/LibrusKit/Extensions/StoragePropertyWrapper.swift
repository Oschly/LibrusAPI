//
//  StoragePropertyWrapper.swift
//  LibrusKit
//
//  Created by Oskar on 16/04/2020.
//

import Foundation

// TODO: - Refactor to use Keychain instead of UserDefaults.
@propertyWrapper
struct Storage<T: Codable> {
  private let key: String
  private let defaultValue: T
  
  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  var wrappedValue: T {
    get {
      if let data = UserDefaults.standard.data(forKey: key) {
        return try! PropertyListDecoder().decode(T.self, from: data)
      } else {
        return defaultValue
      }
      
    }
    set {
      // Set value to UserDefaults
      UserDefaults.standard.set(
        try? PropertyListEncoder().encode(newValue),
        forKey: key)
    }
  }
}

extension Storage where T: RefreshableToken {
  var wrappedValue: T {
    get {
      if let data = UserDefaults.standard.data(forKey: key) {
        let token = try! PropertyListDecoder().decode(T.self, from: data)
        if token.expiration < Date() {
          return defaultValue
        }
        
        return token
      } else {
        return defaultValue
      }
    }
    set {
      UserDefaults.standard.set(
        try! PropertyListEncoder().encode(newValue),
        forKey: key)
    }
  }
}
