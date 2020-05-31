//
//  RefreshTokenOperation.swift
//  LibrusKit
//
//  Created by Oskar on 25/04/2020.
//

import Foundation

class RefreshTokenOperation: AsyncOperation {
  let url = "https://portal.librus.pl/api/v2/SynergiaAccounts/<login>/fresh"
  var completion: ((Result<String, Error>) -> Void)?
  
  let token: String
  let login: String
  
  init(token: String, login: String) {
    self.token = token
    self.login = login
    super.init()
  }
  
  override func main() {
    state = .executing
    
    let url = URL(string: "https://portal.librus.pl/api/v2/SynergiaAccounts/fresh/\(login)")!
    
    var request = URLRequest(url: url)
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.completion?(.success(self.token))
        self.state = .finished
      }
    }
    .resume()
  }
}
