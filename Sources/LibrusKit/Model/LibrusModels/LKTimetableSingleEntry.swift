//
//  LKTimetableSingleEntry.swift
//  LibrusKit
//
//  Created by Oskar on 18/06/2020.
//

import Foundation

public struct LKTimetableSingleEntry: Codable {
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
    case isSubstitution = "IsSubstitutionClass"
    case canceled = "IsCanceled"
    case substitutionNote = "SubstitutionNote"
    case hourFrom = "HourFrom"
    case hourTo = "HourTo"
    case virtualClass = "VirtualClass"
    case virtualClassName = "VirtualClassName"
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
  public let isSubstitution: Bool
  public let canceled: Bool
  public let substitutionNote: String?
  public let hourFrom: String
  public let hourTo: String
  public let virtualClass: LKVirtualClass?
  public let virtualClassName: String?
  
  public init(lesson: LKLesson, classroom: LKClass?, from: Date, to: Date, lessonNumber: String, entry: TimetableEntry, dayNumber: String, subject: LKSubject, teacher: LKTeacher, standardClass: LKClass?, isSubstitution: Bool, canceled: Bool, substitutionNote: String?, hourFrom: String, hourTo: String, virtualClass: LKVirtualClass?, virtualClassName: String?) {
    self.lesson = lesson
    self.classroom = classroom
    self.from = from
    self.to = to
    self.lessonNumber = lessonNumber
    self.entry = entry
    self.dayNumber = dayNumber
    self.subject = subject
    self.teacher = teacher
    self.standardClass = standardClass
    self.isSubstitution = isSubstitution
    self.canceled = canceled
    self.substitutionNote = substitutionNote
    self.hourFrom = hourFrom
    self.hourTo = hourTo
    self.virtualClass = virtualClass
    self.virtualClassName = virtualClassName
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.lesson = try container.decode(LKLesson.self, forKey: .lesson)
    self.classroom = try container.decode(LKClass.self, forKey: .classroom)
    self.lessonNumber = try container.decode(String.self, forKey: .lessonNumber)
    self.entry = try container.decode(TimetableEntry.self, forKey: .entry)
    self.dayNumber = try container.decode(String.self, forKey: .dayNumber)
    self.subject = try container.decode(LKSubject.self, forKey: .subject)
    self.teacher = try container.decode(LKTeacher.self, forKey: .teacher)
    self.standardClass = try? container.decode(LKClass.self, forKey: .standardClass)
    self.isSubstitution = try container.decode(Bool.self, forKey: .isSubstitution)
    self.canceled = try container.decode(Bool.self, forKey: .canceled)
    self.hourFrom = try container.decode(String.self, forKey: .hourFrom)
    self.hourTo = try container.decode(String.self, forKey: .hourTo)
    self.virtualClass = try? container.decode(LKVirtualClass.self, forKey: .virtualClass)
    self.virtualClassName = try? container.decode(String.self, forKey: .virtualClassName)
    
    let stringDateFrom = try container.decode(String.self, forKey: .from)
    self.from = DateFormatter.ISO8601WithoutTime.date(from: stringDateFrom)!
    
    let stringDateTo = try container.decode(String.self, forKey: .to)
    self.to = DateFormatter.ISO8601WithoutTime.date(from: stringDateTo)!
    
    if !(try container.decodeNil(forKey: .substitutionNote)) {
      self.substitutionNote = try container.decode(String.self, forKey: .substitutionNote)
    } else {
      self.substitutionNote = nil
    }
  }
  
  public func fetchedInfo(token: String, _ completion: @escaping ((Result<LKTimetableSingleEntry, Error>) -> Void)) {
    DispatchQueue.global().async {
      let operations = OperationQueue()
      operations.underlyingQueue = DispatchQueue.global(qos: .utility)
      
      var fetchedLesson = self.lesson
      var fetchedClassroom = self.classroom
      var fetchedEntry = self.entry
      var fetchedTeacher = self.teacher
      var fetchedVirtualClass = self.virtualClass
      var fetchedSubject = self.subject
      var fetchedClass = self.standardClass
      
      
      let lessonOperation = FetchObjectOperation<LKLesson>(token: token, object: fetchedLesson) { result in
        do {
          let object = try result.get()
          fetchedLesson = object
        } catch {
          print(error)
        }
      }
      
      operations.addOperation(lessonOperation)
      
      if let classroom = fetchedClassroom {
        let classroomOperation = FetchObjectOperation<LKClass>(token: token, object: classroom) { result in
          do {
            let object = try result.get()
            fetchedClassroom = object
          } catch {
            print(error)
          }
        }
        operations.addOperation(classroomOperation)

      }
      
      let entryOperation = FetchObjectOperation<TimetableEntry>(token: token, object: fetchedEntry) { result in
        do {
          let object = try result.get()
          fetchedEntry = object
        } catch {
          print(error)
        }
      }
      
      operations.addOperation(entryOperation)
      
      
      let teacherOperation = FetchObjectOperation<LKTeacher>(token: token, object: fetchedTeacher) { result in
        do {
          let object = try result.get()
          fetchedTeacher = object
        } catch {
          print(error)
        }
      }
      
      operations.addOperation(teacherOperation)
      
      
      if let virtualClass = fetchedVirtualClass {
        let operation = FetchObjectOperation<LKVirtualClass>(token: token, object: virtualClass) { result in
          do {
            let object = try result.get()
            fetchedVirtualClass = object
          } catch {
            print(error)
          }
        }
        
        operations.addOperation(operation)
      }
      
      let subjectOperation = FetchObjectOperation<LKSubject>(token: token, object: fetchedSubject) { result in
        do {
          let object = try result.get()
          fetchedSubject = object
        } catch {
          print(error)
        }
      }
      
      operations.addOperation(subjectOperation)
      
      
      if let standardClass = fetchedClass {
        let classOperation = FetchObjectOperation<LKClass>(token: token, object: standardClass) { result in
          do {
            let object = try result.get()
            fetchedClass = object
          } catch {
            print(error)
          }
        }
        
        operations.addOperation(classOperation)
      }
      
      operations.waitUntilAllOperationsAreFinished()
      let event = LKTimetableSingleEntry(lesson: fetchedLesson,
                              classroom: fetchedClassroom,
                              from: self.from,
                              to: self.to,
                              lessonNumber: self.lessonNumber,
                              entry: fetchedEntry,
                              dayNumber: self.dayNumber,
                              subject: fetchedSubject,
                              teacher: fetchedTeacher,
                              standardClass: fetchedClass,
                              isSubstitution: self.isSubstitution,
                              canceled: self.canceled,
                              substitutionNote: self.substitutionNote,
                              hourFrom: self.hourFrom,
                              hourTo: self.hourTo,
                              virtualClass: fetchedVirtualClass,
                              virtualClassName: self.virtualClassName)
      
      completion(.success(event))
    }
  }
}
