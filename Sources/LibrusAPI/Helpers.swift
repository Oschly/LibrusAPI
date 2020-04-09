//
//  Helpers.swift
//  LibrusAPI
//
//  Created by Oskar on 09/04/2020.
//

import Foundation

typealias CSRFToken = Token
typealias AuthCode = Token
typealias AccessToken = Token

protocol RefreshableToken {
  var key: String { get set }
  var creationDate: Date { get set }
}

struct Token: RefreshableToken {
  var key: String
  var creationDate = Date()
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

