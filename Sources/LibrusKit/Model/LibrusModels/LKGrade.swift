//
//  Grade.swift
//  LibrusKit
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public struct LKGrade: Codable {
  public let id: Int
  
  public let lesson: LKLesson
  
  public let subject: LKSubject
  
  public let student: LKStudent
  
  public let category: LKCategory
  
  public let teacher: LKTeacher
  
  public let grade: String
  
  public let date: Date
  
  public let addDate: Date
  
  public let semester: LKSemester
  
  public let type: LKGradeType?
  
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case lesson = "Lesson"
    case subject = "Subject"
    case student = "Student"
    case category = "Category"
    case teacher = "AddedBy"
    case grade = "Grade"
    case date = "Date"
    case addDate = "AddDate"
    case semester = "Semester"
  }
  
  public init(from decoder: Decoder) throws {
    guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { preconditionFailure() }
    do {
      self.id = try container.decode(Int.self, forKey: .id)
      self.lesson = try container.decode(LKLesson.self, forKey: .lesson)
      self.subject = try container.decode(LKSubject.self, forKey: .subject)
      self.student = try container.decode(LKStudent.self, forKey: .student)
      self.category = try container.decode(LKCategory.self, forKey: .category)
      self.teacher = try container.decode(LKTeacher.self, forKey: .teacher)
      self.semester = try container.decode(LKSemester.self, forKey: .semester)
      self.grade = try container.decode(String.self, forKey: .grade)
      
      var dateString = try! container.decode(String.self, forKey: .date)
      self.date = DateFormatter.ISO8601WithoutTime.date(from: dateString)!
      
      dateString = try! container.decode(String.self, forKey: .addDate)
      self.addDate = DateFormatter.ISO8601WithTime.date(from: dateString)!
      
      self.type = try LKGradeType(from: decoder)
      return
    } catch {
      // TODO: To be handled
      print(error)
    }
    
    preconditionFailure()
  }
}
