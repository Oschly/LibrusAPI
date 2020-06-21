//
//  ShortFormed.swift
//  LibrusKit
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

public protocol ShortFormed: Hashable, Codable {
  var id: Int? { get }
  
  var url: URL? { get }
  
  init(from decoder: Decoder) throws
  
  func fetchedInfo(token: String, _ completion: @escaping ((Result<Self, Error>) -> Void))
}

public extension ShortFormed {
  static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}

public extension ShortFormed where Self: NestedInJSON {
  /// Has to be executed on background thread, otherwise semaphore in method will freeze main thread.
  /// - Parameter token: Used to acquire object's data
  /// - Returns: If method didn't failed to fetch data, it will return filled `ShortFormed` with rest of its objects.
  func fetchedInfo(token: String, _ completion: @escaping ((Result<Self, Error>) -> Void)) {
    guard let url = url else { preconditionFailure() }
    
    var request = URLRequest(url: url)
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print(error)
      }
      
      if let data = data {
        do {
          let decodedResponse = try JSONDecoder.shared.decode(Response<Self>.self, from: data)
          completion(.success(decodedResponse.root))
        } catch {
          completion(.failure(error))
          dump(String(data: data, encoding: .utf8))
          
        }
      }
    }
    .resume()
  }
}

enum ShortFormedCodingKeys: String, CodingKey {
  case id = "Id"
  case url = "Url"
}
