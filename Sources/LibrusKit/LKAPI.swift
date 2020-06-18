//
//  LibrusAPI.swift
//  LibrusKit
//
//  Created by Oskar on 31/05/2020.
//

import Foundation

public final class LKAPI {
  static public let instance = LKAPI()
  
  // TODO: Fix that
  public func getHomework(token: String, completion: @escaping (Result<[Homework], Error>) -> ()) {
    let url = URL(string: "https://api.librus.pl/2.0/HomeWorkAssignments")!
    
    var request = URLRequest(url: url)
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      dump(String(data: data!, encoding: .utf8))
    }
    .resume()
  }
  
  public func getEvents(credentials: RefreshCredentials, completion: @escaping ((Result<[LKEvent], Error>) -> ())) {
    let url = URL(string: "https://api.librus.pl/2.0/HomeWorks")!
    
    var request = URLRequest(url: url)
    request.addValue("Bearer \(credentials.token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
      }
      
      guard let data = data else { preconditionFailure() }
      
      do {
        if let decoded = try? JSONDecoder.shared.decode(Response<[LKEvent]>.self, from: data) {
          completion(.success(decoded.root))
        } else {
          let decodedError = try JSONDecoder.shared.decode(ErrorJSON.self, from: data)
          if decodedError.code == .tokenExpired {
            LKAuthenticator.instance.refreshAccessToken(credentials: credentials) { [weak self] in
              guard let self = self else { preconditionFailure() }
              self.getEvents(credentials: credentials, completion: completion)
            }
          }
        }
      } catch {
        print(error)
      }
    }
    .resume()
  }
  
  func getTimetable(credentials: RefreshCredentials, completion: @escaping ((Result<[LKEvent], Error>) -> ())){
    let url = URL(string: "https://api.librus.pl/2.0/Timetables")!
    
    var request = URLRequest(url: url)
    request.addValue("Bearer \(credentials.token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
      }
      
      guard let data = data else { preconditionFailure() }
      
      dump(String(data: data, encoding: .utf8))
    }.resume()
  }
}
