//
//  LKEvent.swift
//  LibrusKit
//
//  Created by Oskar on 30/05/2020.
//

import Foundation

extension Array: NestedInJSON where Element == LKEvent {
  public static var codingKey: ResponseKeys = .events
}

public struct LKEvent: ShortFormed, NestedInJSON {
  private enum CodingKeys: String, CodingKey {
    case content = "Content"
    case subject = "Subject"
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
  
  public let id: Int?
  
  public let url: URL? = nil
  
  public let content: String?
  
  public let date: Date?
  
  public let subject: LKSubject?
  
  public let category: LKCategory?
  
  public let lessonNumber: Int?
  
  public let begin: Date?
  
  public let end: Date?
  
  public let teacher: LKTeacher?
  
  public let forClass: LKClass?
  
  public let virtualClass: LKVirtualClass?
  
  public let addDate: Date?
  
  public let onlineLessonUrl: LKOnlineLesson?
  
  public init(id: Int?, content: String?, date: Date?, category: LKCategory?, lessonNumber: Int?, beginDate: Date?, endDate: Date?, subject: LKSubject?, teacher: LKTeacher?, forClass: LKClass?, virtualClass: LKVirtualClass?, addDate: Date?, onlineLessonUrl: LKOnlineLesson?) {
    self.id = id
    self.content = content
    self.date = date
    self.subject = subject
    self.category = category
    self.lessonNumber = lessonNumber
    self.begin = beginDate
    self.end = endDate
    self.teacher = teacher
    self.forClass = forClass
    self.virtualClass = virtualClass
    self.addDate = addDate
    self.onlineLessonUrl = onlineLessonUrl
  }
  
  public init(from decoder: Decoder) throws {
    guard let shortFormedContainer = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    self.id = try? shortFormedContainer.decode(Int.self, forKey: .id)
    
    guard let baseContainer = try? decoder
      .container(keyedBy: CodingKeys.self)
      else { preconditionFailure()}
    
    self.content = try? baseContainer.decode(String.self, forKey: .content)
    self.teacher = try baseContainer.decode(LKTeacher.self, forKey: .teacher)
    self.subject = try? baseContainer.decode(LKSubject.self, forKey: .subject)
    self.forClass = try? baseContainer.decode(LKClass.self, forKey: .forClass)
    self.category = try baseContainer.decode(LKCategory.self, forKey: .category)
    self.virtualClass = try? baseContainer.decode(LKVirtualClass.self, forKey: .virtualClass)
    self.onlineLessonUrl = try? baseContainer.decode(LKOnlineLesson.self, forKey: .onlineLessonUrl)
    
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
  
  public func fetchedInfo(token: String, _ completion: @escaping ((Result<LKEvent, Error>) -> Void)) {
    DispatchQueue.global().async {
      let operations = OperationQueue()
      operations.underlyingQueue = DispatchQueue.global(qos: .utility)
      
      var fetchedCategory = self.category
      var fetchedTeacher = self.teacher
      var fetchedClass = self.forClass
      var fetchedVirtualClass = self.virtualClass
      var fetchedSubject = self.subject
      
      
      if let category = fetchedCategory {
        let operation = FetchObjectOperation<LKCategory>(token: token, object: category) { result in
          do {
            let object = try result.get()
            fetchedCategory = object
          } catch {
            print(error)
          }
        }
        
        operations.addOperation(operation)
      }
      
      
      if let teacher = fetchedTeacher {
        let operation = FetchObjectOperation<LKTeacher>(token: token, object: teacher) { result in
          do {
            let object = try result.get()
            fetchedTeacher = object
          } catch {
            print(error)
          }
        }
        
        operations.addOperation(operation)
      }
      
      
      if let forClass = fetchedClass {
        let operation = FetchObjectOperation<LKClass>(token: token, object: forClass) { result in
          do {
            let object = try result.get()
            fetchedClass = object
          } catch {
            print(error)
          }
        }
        
        operations.addOperation(operation)
      }
      
      
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
      
      if let subject = fetchedSubject {
        let operation = FetchObjectOperation<LKSubject>(token: token, object: subject) { result in
          do {
            let object = try result.get()
            fetchedSubject = object
          } catch {
            print(error)
          }
        }
        
        operations.addOperation(operation)
      }
      
      operations.waitUntilAllOperationsAreFinished()
      let event = LKEvent(id: self.id,
                          content: self.content,
                          date: self.date, category: fetchedCategory,
                          lessonNumber: self.lessonNumber,
                          beginDate: self.begin,
                          endDate: self.end,
                          subject: fetchedSubject,
                          teacher: fetchedTeacher,
                          forClass: fetchedClass,
                          virtualClass: fetchedVirtualClass,
                          addDate: self.addDate,
                          onlineLessonUrl: self.onlineLessonUrl)
      
      completion(.success(event))
    }
  }
}
