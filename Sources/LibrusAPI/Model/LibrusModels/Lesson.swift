//
//  Lesson.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

struct Lesson: ShortFormed {
  private enum CodingKeys: String, CodingKey {
    case teacher = "Teacher"
    case subject = "Subject"
    case classRoom = "Class"
  }
  
  let id: Int?
  
  let url: URL?
  
  let teacher: Teacher?
  
  let subject: Subject?
  
  let classRoom: Class?
  
  init(from decoder: Decoder) {
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
    
    self.teacher = try? baseContainer.decode(Teacher.self, forKey: .teacher)
    self.subject = try? baseContainer.decode(Subject.self, forKey: .subject)
    self.classRoom = try? baseContainer.decode(Class.self, forKey: .classRoom)
  }
}

extension Lesson: DecodableFromNestedJSON {
  static var codingKey: ResponseKeys = .lesson
}
