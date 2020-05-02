//
//  JSONDecoder+Singleton.swift
//  LibrusAPI
//
//  Created by Oskar on 16/04/2020.
//

import Foundation

extension JSONDecoder {
  static let shared: JSONDecoder = {
    let decoder = JSONDecoder()
    return decoder
  }()
}

extension JSONEncoder {
  static let shared: JSONEncoder = {
    var encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.outputFormatting = .withoutEscapingSlashes
    return encoder
  }()
}
