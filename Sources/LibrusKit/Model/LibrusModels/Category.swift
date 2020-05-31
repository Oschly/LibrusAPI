//
//  Category.swift
//  LibrusKit
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public struct Category: ShortFormed {
  enum CodingKeys: String, CodingKey {
    case color = "Color"
    case name = "Name"
    case adultsExtramural = "AdultsExtramural"
    case adultsDaily = "AdultsDaily"
    case standard = "Standard"
    case blockAnyGrades = "BlockAnyGrades"
    case obligationToPerform = "ObligationToPerform"
  }
  
  public let id: Int?
  
  public let url: URL?
  
  public let color: CategoryColor?
  
  public let name: String?
  
  public let adultsExtramural: Bool?
  
  public let adultsDaily: Bool?
  
  public let standard: Bool?
  
  public let blockAnyGrades: Bool?
  
  public let obligationToPerform: Bool?
  
  public init(from decoder: Decoder) {
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
  public static var codingKey: ResponseKeys = .category
}
