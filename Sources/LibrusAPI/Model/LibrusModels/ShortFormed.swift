//
//  ShortFormed.swift
//  LibrusAPI
//
//  Created by Oskar on 26/04/2020.
//

import Foundation

protocol ShortFormed {
  var id: Int? { get }
  
  var url: URL? { get }
  
  init(from decoder: Decoder)
  
  func fetchedInfo(token: String) -> Self
}

extension ShortFormed where Self: DecodableFromNestedJSON {
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
