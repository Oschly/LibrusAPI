//
//  Event.swift
//  LibrusAPI
//
//  Created by Oskar on 30/05/2020.
//

import Foundation

public struct Event: ShortFormed, DecodableFromNestedJSON {
  private enum CodingKeys: String, CodingKey {
    case content = "Content"
    case date = "Date"
    case category = "Category"
    case lessonNumber = "LessonNo"
    case begin = "TimeFrom"
    case end = "TimeTo"
    case teacher = "CreatedBy"
    case forClass = "Class"
    case virtualClass = "VirtualClass"
    case addDate = "AddDate"
    case onlineLessonUrl = "onlineLessonUrl"
  }
  
  public static var codingKey: ResponseKeys = .events
  
  let id: Int?
  
  let url: URL?
  
  let content: String?
  
  let date: Date?
  
  let category: Category?
  
  let lessonNumber: Int?
  
  let begin: Date?
  
  let end: Date?
  
  let teacher: Teacher?
  
  let forClass: Class?
  
  let virtualClass: VirtualClass?
  
  let addDate: Date?
  
  let onlineLessonUrl: OnlineLesson?
  
  public init(from decoder: Decoder) throws {
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
      else { preconditionFailure()}
    
    self.content = try? baseContainer.decode(String.self, forKey: .content)
    self.teacher = try baseContainer.decode(Teacher.self, forKey: .teacher)
    self.forClass = try? baseContainer.decode(Class.self, forKey: .forClass)
    self.category = try? baseContainer.decode(Category.self, forKey: .category)
    self.virtualClass = try? baseContainer.decode(VirtualClass.self, forKey: .virtualClass)
    self.onlineLessonUrl = try? baseContainer.decode(OnlineLesson.self, forKey: .onlineLessonUrl)
    
    
    if let dateString = try? baseContainer.decode(String.self, forKey: .date) {
      self.date = DateFormatter.ISO8601WithoutTime.date(from: dateString)?.addingTimeInterval(7200)
    } else {
      self.date = nil
    }
    
    if (try? !baseContainer.decodeNil(forKey: .lessonNumber)) ?? false {
      self.lessonNumber = Int(try baseContainer.decode(String.self, forKey: .lessonNumber))
    } else {
      self.lessonNumber = nil
    }
    
    if let beginString = try? baseContainer.decode(String.self, forKey: .begin) {
      self.begin = DateFormatter.hourFormatter.date(from: beginString)
    } else {
      self.begin = nil
    }
    
    if let endString = try? baseContainer.decode(String.self, forKey: .end) {
      self.end = DateFormatter.hourFormatter.date(from: endString)
    } else {
      self.end = nil
    }

    
    if let addDateString = try? baseContainer.decode(String.self, forKey: .addDate) {
      self.addDate = DateFormatter.ISO8601WithoutTime.date(from: addDateString)
    } else {
      self.addDate = nil
    }
  }
}
