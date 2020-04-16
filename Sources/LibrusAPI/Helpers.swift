//
//  Helpers.swift
//  LibrusAPI
//
//  Created by Oskar on 09/04/2020.
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
  let expiration = Date()
}

protocol LibrusAPIError: Error {}

enum APIError: LibrusAPIError {
  case errorGettingCSRF(info: URLError)
  case connectionError
  case noCredentials
  case other
}

enum ScrappingError: LibrusAPIError {
  case errorConnection
  case errorDecodingData
  case errorGettingAttribute
}

