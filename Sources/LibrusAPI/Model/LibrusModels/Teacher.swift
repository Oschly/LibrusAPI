//
//  Teacher.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

struct Teacher: ShortFormed, User {
  
  private(set) var accountId: String? = nil
  
  private(set) var firstName: String? = nil
  
  private(set) var lastName: String? = nil
  
  private(set) var id: Int?
  
  private(set) var url: URL?
  
  init(from decoder: Decoder) {
    guard let shortFormedContainer = try? decoder
      .container(keyedBy: ShortFormedCodingKeys.self)
      else { preconditionFailure() }
    
    if let id = try? shortFormedContainer.decode(Int.self, forKey: .id) {
      self.id = id
    }
    
    if let stringUrl = try? shortFormedContainer.decode(String.self, forKey: .url) {
      self.url = URL(string: stringUrl)!
    }
  }
  
  // Initialiser for `fetchedInfo(token:)` method.
  init(accountId: String?, firstName: String?, lastName: String?, id: Int?, url: URL?) {
    self.accountId = accountId
    self.firstName = firstName
    self.lastName = lastName
    self.id = id
    self.url = url
  }
  
  /// Has to be executed on background thread, otherwise semaphore in method will freeze main thread.
  /// - Parameter token: Used to acquire Teacher's data
  /// - Returns: If method didn't failed to fetch data, it will return filled `Teacher` object.
  func fetchedInfo(token: String) -> Teacher {
    guard let url = url else { preconditionFailure() }
    let semaphore = DispatchSemaphore(value: 0)
    
    var teacher = Teacher(accountId: nil, firstName: nil, lastName: nil, id: id, url: url)
    
    var request = URLRequest(url: url)
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      defer { semaphore.signal() }
      
      if let error = error {
        print(error)
      }
      
      if let data = data {
        if let decodedResponse = try? JSONDecoder.shared.decode(UserResponse.self, from: data) {
          let user = decodedResponse.user
          teacher = Teacher(accountId: user.accountId,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            id: user.id,
                            url: url)
          semaphore.signal()
        } else {
          print("Decoding teacher's info failed")
          semaphore.signal()
        }
      }
    }
    .resume()
    
    semaphore.wait()
    return teacher
  }
}
