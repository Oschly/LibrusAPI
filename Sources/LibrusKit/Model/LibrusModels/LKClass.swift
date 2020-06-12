//
//  LKClass.swift
//  LibrusKit
//
//  Created by Oskar on 05/05/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation

public struct LKClass: ShortFormed {
  private enum CodingKeys: String, CodingKey {
    case number = "Number"
    case symbol = "Symbol"
    case beginSchoolYear = "BeginSchoolYear"
    case endFirstSemester = "EndFirstSemester"
    case endSchoolYear = "EndSchoolYear"
    case classUnit = "Unit"
    case tutors = "ClassTutors"
  }
  
  private(set) public var id: Int?
  
  private(set) public var url: URL?
  
  public let number: Int?
  
  public let symbol: String?
  
  public let beginSchoolYear: Date?
  
  public let endFirstSemester: Date?
  
  public let endSchoolYear: Date?
  
  public let classUnit: LKSchool?
  
  public let tutors: [LKTeacher]?
  
  public init(from decoder: Decoder) {
    guard let shortFormedContainer = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try? shortFormedContainer.decode(Int.self, forKey: .id)
    
    if let urlString = try? shortFormedContainer.decode(String.self, forKey: .url) {
      self.url = URL(string: urlString)
    } else {
      self.url = nil
    }
    
    guard let baseContainer = try? decoder
      .container(keyedBy: CodingKeys.self)
      else { preconditionFailure() }
    
    self.number = try? baseContainer.decode(Int.self, forKey: .number)
    self.symbol = try? baseContainer.decode(String.self, forKey: .symbol)
    self.classUnit = try? baseContainer.decode(LKSchool.self, forKey: .classUnit)
    self.tutors = try? baseContainer.decode([LKTeacher].self, forKey: .tutors)
    
    if let beginSchoolYearString = try? baseContainer.decode(String.self, forKey: .beginSchoolYear) {
      self.beginSchoolYear = DateFormatter.ISO8601WithoutTime.date(from: beginSchoolYearString)
    } else {
      self.beginSchoolYear = nil
    }
    
    if let endFirstSemesterString = try? baseContainer.decode(String.self, forKey: .endFirstSemester) {
      self.endFirstSemester = DateFormatter.ISO8601WithoutTime.date(from: endFirstSemesterString)
    } else {
      self.endFirstSemester = nil
    }
    
    if let endSchoolYearString = try? baseContainer.decode(String.self, forKey: .endSchoolYear) {
      self.endSchoolYear = DateFormatter.ISO8601WithoutTime.date(from: endSchoolYearString)
    } else {
      self.endSchoolYear = nil
    }
  }
}

extension LKClass: NestedInJSON {
  public static var codingKey: ResponseKeys = .standardClass
}
