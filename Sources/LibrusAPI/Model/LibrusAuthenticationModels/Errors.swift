//
//  Errors.swift
//  LibrusAPI
//
//  Created by Oskar on 16/04/2020.
//

import Foundation

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
