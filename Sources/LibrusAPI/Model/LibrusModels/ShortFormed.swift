//
//  ShortFormed.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

protocol ShortFormed {
  var id: Int { get }
  var url: URL { get }
  
  init(from decoder: Decoder)
}

enum ShortFormedCodingKeys: String, CodingKey {
  case id = "Id"
  case url = "Url"
}
