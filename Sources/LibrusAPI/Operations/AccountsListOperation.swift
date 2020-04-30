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
  var list: AccessList?
  
  @Storage<AccessToken?>(key: "accessToken", defaultValue: nil)
  private(set) var accessToken: AccessToken?
  
  override func main() {
    state = .executing
    guard let accessToken = accessToken else { preconditionFailure() }
    
    let url = URL(string: "https://portal.librus.pl/api/v2/SynergiaAccounts")!
    var request = URLRequest(url: url)
    
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    request.addValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      guard let self = self else { return }
      if let error = error {
        print("AccountsList: Error: \(error)")
        return
      }
      
      if let data = data,
        let list = try? JSONDecoder.shared.decode(AccessList.self, from: data) {
        print("Successfully acquired AccessList, saving it for later use.")
        self.completion?(.success(list))
        self.list = list
        self.state = .finished
      }
    }
    .resume()
  }
  
  override func start() {
    main()
    print("Finsiehd")
  }
}
