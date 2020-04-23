//
//  AccountsListOperation.swift
//  LibrusAPI
//
//  Created by Oskar on 23/04/2020.
//

import Foundation

final class AccountsListOperation: AsyncOperation {
  // To be considered for further implementation
  var completion: ((Result<AccessList, Error>) -> ())?
  
  override func main() {
    guard let accessToken = dependencies
      .compactMap({ ($0 as? AccessTokenOperation)?.accessToken })
      .first
      else { preconditionFailure() }
    
    let url = URL(string: "https://portal.librus.pl/api/v2/SynergiaAccounts")!
    var request = URLRequest(url: url)
    
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    request.addValue("\(accessToken.type) \(accessToken.token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      guard let self = self else { return }
      if let error = error {
        print(error)
        self.completion?(.failure(error))
        return
      }
      
      if let data = data {
        let list = try! JSONDecoder.shared.decode(AccessList.self, from: data)
        self.completion?(.success(list))
      }
    }
    .resume()
  }
}
