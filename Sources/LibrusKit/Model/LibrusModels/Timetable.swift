//
//  Timetable.swift
//  LibrusKit
//
//  Created by Oskar on 18/06/2020.
//

import Foundation

public struct Timetable: Codable {
  enum CodingKeys: String, CodingKey {
    case lesson = "Lesson"
    case classroom = "Classroom"
    case from = "DateFrom"
    case to = "DateTo"
    case lessonNumber = "LessonNo"
    case entry = "TimetableEntry"
    case dayNumber = "DayNumber"
    case subject = "Subject"
    case teacher = "Teacher"
    case standardClass = "Class"
    case isSubstitutionClass = "IsSubstitutionClass"
    case canceled = "IsCanceled"
    case subNote = "SubstitutionNote"
    case hourFrom = "HourFrom"
    case hourTo = "HourTo"
  }
  
  public let lesson: LKLesson
  public let classroom: LKClass?
  public let from: Date
  public let to: Date
  public let lessonNumber: String
  public let entry: TimetableEntry
  public let dayNumber: String
  public let subject: LKSubject
  public let teacher: LKTeacher
  public let standardClass: LKClass?
  public let isSubstitutionClass: Bool
  public let canceled: Bool
  public let subNote: String?
  public let hourFrom: String
  public let hourTo: String
  public let virtualClass: LKVirtualClass?
  public let virtualClassName: String?
  
  public init(from decoder: Decoder) throws {
    #error("Not implemented yet")
  }
}
