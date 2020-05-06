//
//  GradeType.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public enum GradeType: String, Codable {
  case constituent
  
  case semester
  
  case semesterProposition
  
  case final
  
  case finalProposition
  
  enum CodingKeys: String, CodingKey {
    // Decoding from server
    case isConstituent = "IsConstituent"
    case isSemester = "IsSemester"
    case isSemesterProposition = "IsSemesterProposition"
    case isFinalProposition = "IsFinalProposition"
    
    // Decoding from storage
    case gradeType = "gradeType"
  }
  
  public init(from decoder: Decoder) throws {
    guard let container = try? decoder.container(keyedBy: CodingKeys.self)
      else { preconditionFailure() }
    
    // Decode from storage
    if let rawValue = try? container.decode(String.self, forKey: .gradeType),
      let type = GradeType(rawValue: rawValue) {
      self = type
      return
    }
    
    // Decode from server response's data.
    let isConstituent = try! container.decode(Bool.self, forKey: .isConstituent)
    let isSemester = try! container.decode(Bool.self, forKey: .isSemester)
    let isSemesterProposition = try! container.decode(Bool.self, forKey: .isSemesterProposition)
    let isFinalProposition = try! container.decode(Bool.self, forKey: .isFinalProposition)
    
    if isConstituent {
      self = .constituent
    } else if isSemester {
      self = .semester
    } else if isSemesterProposition {
      self = .semesterProposition
    } else if isFinalProposition {
      self = .finalProposition
    } else {
      self = .final
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    do {
      try container.encode(rawValue, forKey: .gradeType)
    } catch {
      // TODO: To be handled in better way
      print(error)
    }
  }
}
