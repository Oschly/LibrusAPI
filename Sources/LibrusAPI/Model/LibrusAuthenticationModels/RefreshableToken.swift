//
//  RefreshableToken.swift
//  LibrusAPI
//
//  Created by Oskar on 16/04/2020.
//

import Foundation

typealias CSRFToken = Token
typealias AuthCode = Token

protocol RefreshableToken: Codable {
  var token: String { get }
  var expiration: Date { get }
}

struct Token: RefreshableToken {
  let token: String
  let expiration = Date().addingTimeInterval(360)
}
