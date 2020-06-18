//
//  Timetable.swift
//  LibrusKit
//
//  Created by Oskar on 18/06/2020.
//

import Foundation

public struct Timetable: Codable {
  public let lesson: LKLesson
  public let classroom: LKClass?
  public let from: Date
  public let to: Date
  public let lessonNo: String
//public   let timetableEntry
  public let dayNumber: String
  public let subject: LKSubject
  public let teacher: LKTeacher
//public   let timetableClass: Class?
  public let isSubstitutionClass: Bool
  public let isCanceled: Bool
  public let substitutionNote: String?
  public let hourFrom: String
  public let hourTo: String
  public let virtualClass: LKVirtualClass?
  public let virtualClassName: String?
}
