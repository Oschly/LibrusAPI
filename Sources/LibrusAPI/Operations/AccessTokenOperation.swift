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
  @Storage<AccessToken?>(key: "accessToken", defaultValue: nil)
  private(set) var accessToken: AccessToken?
  
  @Storage<AuthCode?>(key: "authCode", defaultValue: nil)
  var authCode: AuthCode?
  
  override func main() {
    state = .executing
    guard let authCode = authCode
      else {
        print("AccessToken: AuthCode is not present, skipping (did you started that operation without chaining it to acquiring auth code operation?)")
        state = .finished
        return
    }
    
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
          print("AccessToken: Failed to retrieve AccessToken, error: \(error)")
          return
        }
        
        guard let data = data else { return }
        
        DispatchQueue.main.async {
          if let token = try? JSONDecoder().decode(AccessToken.self, from: data) {
            print("AccessToken: Acquired AccessToken, assigning it for later use.")
            self.accessToken = token
            self.state = .finished
            
            // Somehow after single request, authCode is getting revoked. To avoid issues,
            // just remove value after its first use.
            UserDefaults.standard.removeObject(forKey: "authCode")
            return
          } else {
            preconditionFailure("Decoding AccessToken resulted in failure.")
          }
        }
    }
    .resume()
  }
  
  override func start() {
    main()
  }
}
