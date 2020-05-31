//
//  ShortFormed.swift
//  LibrusKit
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

protocol ShortFormed {
  var id: Int? { get }
  
  var url: URL? { get }
  
  init(from decoder: Decoder) throws
  
  func fetchedInfo(token: String) -> Self
}

extension ShortFormed where Self: DecodableFromNestedJSON {
  /// Has to be executed on background thread, otherwise semaphore in method will freeze main thread.
  /// - Parameter token: Used to acquire object's data
  /// - Returns: If method didn't failed to fetch data, it will return filled `ShortFormed` with rest of its objects.
  func fetchedInfo(token: String) -> Self {
    guard let url = url else { preconditionFailure() }
      let semaphore = DispatchSemaphore(value: 0)
      
      var category = self
      
      var request = URLRequest(url: url)
      request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
      request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      
      URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        if let error = error {
          print(error)
        }
        
        if let data = data {
          if let decodedResponse = try? JSONDecoder.shared.decode(Response<Self>.self, from: data) {
            category = decodedResponse.root
            semaphore.signal()
          } else {
            print("Decoding \(String(describing: category.id)) info failed")
            dump(String(data: data, encoding: .utf8))
            semaphore.signal()
          }
        }
      }
      .resume()
      
      semaphore.wait()
      return category
  }
}

enum ShortFormedCodingKeys: String, CodingKey {
  case id = "Id"
  case url = "Url"
}
