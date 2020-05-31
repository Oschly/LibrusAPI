//
//  LibrusAPI.swift
//  LibrusKit
//
//  Created by Oskar on 31/05/2020.
//

import Foundation

public final class LKAPI {
  static let instance = LKAPI()
  
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
  
  public func getEvents(token: String, completion: @escaping ((Result<[LKEvent], Error>) -> ())) {
    let url = URL(string: "https://api.librus.pl/2.0/HomeWorks")!
    
    var request = URLRequest(url: url)
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
      }
      
      guard let data = data else { preconditionFailure() }
      
      do {
        let decoded = try JSONDecoder.shared.decode(Response<[LKEvent]>.self, from: data)
        completion(.success(decoded.root))
      } catch {
        print(error)
      }
    }
    .resume()
  }
}
