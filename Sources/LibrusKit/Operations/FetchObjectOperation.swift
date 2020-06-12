//
//  FetchObjectOperation.swift
//  LibrusKit
//
//  Created by Oskar on 11/06/2020.
//

import Foundation

class FetchObjectOperation<T: ShortFormed>: AsyncOperation {
  let completion: (Result<T, Error>) -> ()
  let token: String
  let object: T
  
  init(token: String, object: T, completion: @escaping (Result<T, Error>) -> ()) {
    self.completion = completion
    self.token = token
    self.object = object
  }
  
  override func main() {
    object.fetchedInfo(token: token) { result in
      do {
        let newObject = try result.get()
        self.completion(.success(newObject))
        self.state = .finished
      } catch {
        print(error)
        self.completion(.failure(error))
        self.state = .finished
      }
    }
  }
}
