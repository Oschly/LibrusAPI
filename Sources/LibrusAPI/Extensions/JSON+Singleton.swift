//
//  JSONDecoder+Singleton.swift
//  LibrusAPI
//
//  Created by Oskar on 16/04/2020.
//

import Foundation

extension JSONDecoder {
  static let shared = JSONDecoder()
}

extension JSONEncoder {
  static let shared: JSONEncoder = {
    var encoder = JSONEncoder()
    encoder.outputFormatting = .withoutEscapingSlashes
    return encoder
  }()
}
