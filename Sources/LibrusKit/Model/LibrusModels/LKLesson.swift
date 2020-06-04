//
//  LKLesson.swift
//  LibrusKit
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public struct LKLesson: ShortFormed {
  private enum CodingKeys: String, CodingKey {
    case teacher = "Teacher"
    case subject = "Subject"
    case classRoom = "Class"
  }
  
  public let id: Int?
  
  public let url: URL?
  
  public let teacher: LKTeacher?
  
  public let subject: LKSubject?
  
  public let classRoom: LKClass?
  
  public init(from decoder: Decoder) {
    guard let shortFormedContainer = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try! shortFormedContainer.decode(Int.self, forKey: .id)
    
    if let urlString = try? shortFormedContainer.decode(String.self, forKey: .url) {
      self.url = URL(string: urlString)
    } else {
      self.url = nil
    }
    
    guard let baseContainer = try? decoder
      .container(keyedBy: CodingKeys.self)
      else { preconditionFailure() }
    
    self.teacher = try? baseContainer.decode(LKTeacher.self, forKey: .teacher)
    self.subject = try? baseContainer.decode(LKSubject.self, forKey: .subject)
    self.classRoom = try? baseContainer.decode(LKClass.self, forKey: .classRoom)
  }
}

extension LKLesson: DecodableFromNestedJSON {
  public static var codingKey: ResponseKeys = .lesson
}
