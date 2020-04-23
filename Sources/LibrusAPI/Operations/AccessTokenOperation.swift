//
//  AccessTokenOperation.swift
//  LibrusAPI
//
//  Created by Oskar on 23/04/2020.
//

import Foundation

/// Access token is last token we need to get all Synergia accounts.
/// For further informations, go to `AccessToken` definition.
final class AccessTokenOperation: AsyncOperation {
  private(set) var accessToken: AccessToken?
  
  override func main() {
    state = .executing
    guard let authCode = dependencies
      .compactMap({ ($0 as? AcquriringAuthCodeOperation)?.authCode })
      .first
      else { return }
    
    let url = URL(string: "https://portal.librus.pl/oauth2/access_token")!
    var request = URLRequest(url: url)
    
    let body = [
      "client_id": "6XPsKf10LPz1nxgHQLcvZ1KM48DYzlBAhxipaXY8",
      "grant_type": "authorization_code",
      "code": authCode.token,
      "redirect_uri": "http://localhost/bar"
      ].queryParameters
    
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = body.data(using: .utf8, allowLossyConversion: true)
    
    URLSession.shared
      .dataTask(with: request) { [weak self] data, response, error in
        guard let self = self else { return }
        if let error = error {
          print(error)
          return
        }
        
        guard let data = data else { return }
        
        DispatchQueue.main.async {
          if let token = try? JSONDecoder.shared.decode(AccessToken.self, from: data) {
            self.accessToken = token
            self.state = .finished
            return
          }
        }
    }
    .resume()
  }
  
  override func start() {
    main()
  }
}
