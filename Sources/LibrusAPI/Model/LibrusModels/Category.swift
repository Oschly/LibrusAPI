//
//  Category.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

struct Category: ShortFormed {
  enum CodingKeys: String, CodingKey {
    case color = "Color"
    case name = "Name"
    case adultsExtramural = "AdultsExtramural"
    case adultsDaily = "AdultsDaily"
    case standard = "Standard"
    case blockAnyGrades = "BlockAnyGrades"
    case obligationToPerform = "ObligationToPerform"
  }
  
  let id: Int?
  
  let url: URL?
  
  let color: CategoryColor?
  
  let name: String?
  
  let adultsExtramural: Bool?
  
  let adultsDaily: Bool?
  
  let standard: Bool?
  
  let blockAnyGrades: Bool?
  
  let obligationToPerform: Bool?
  
  init(from decoder: Decoder) {
    guard let container = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try? container.decode(Int.self, forKey: .id)
    
    if let stringUrl = try? container.decode(String.self, forKey: .url) {
      self.url = URL(string: stringUrl)!
    } else {
      self.url = nil
    }
    
    guard let fullContainer = try? decoder.container(keyedBy: CodingKeys.self) else { preconditionFailure() }
    
    self.color = try? fullContainer.decode(CategoryColor.self, forKey: .color)
    self.name = try? fullContainer.decode(String.self, forKey: .name)
    self.adultsExtramural = try? fullContainer.decode(Bool.self, forKey: .adultsExtramural)
    self.adultsDaily = try? fullContainer.decode(Bool.self, forKey: .adultsDaily)
    self.standard = try? fullContainer.decode(Bool.self, forKey: .standard)
    self.blockAnyGrades = try? fullContainer.decode(Bool.self, forKey: .blockAnyGrades)
    self.obligationToPerform = try? fullContainer.decode(Bool.self, forKey: .obligationToPerform)
  }
}

extension Category: DecodableFromNestedJSON {
  static var codingKey: ResponseKeys = .category
}
