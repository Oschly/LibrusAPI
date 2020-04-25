//
//  RefreshTokenOperation.swift
//  LibrusAPI
//
//  Created by Oskar on 25/04/2020.
//

import Foundation

class RefreshTokenOperation: AsyncOperation {
  let url = "https://portal.librus.pl/api/v2/SynergiaAccounts/<login>/fresh"
  var completion: ((Result<AccessList.SynergiaAccount, Error>) -> Void)?
  
  override func main() {
    state = .executing
    
    // TODO: make that dynamic
    guard let login = dependencies
      .compactMap({ ($0 as? AccountsListOperation )?.list })
      .first?
      .accounts[0]
      else { return }
    
    let url = URL(string: "https://portal.librus.pl/api/v2/SynergiaAccounts/fresh/\(login.login)")!
    
    var request = URLRequest(url: url)
    request.addValue("Bearer \(login.token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      DispatchQueue.main.async {
        self.completion?(.success(login))
      self.state = .finished
      }
    }
  .resume()
  }
}
