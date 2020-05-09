//
//  UpdateCookiesOperation.swift
//  LibrusAPI
//
//  Created by Oskar on 22/04/2020.
//

import Foundation

/// Cookies are needed to successfully get AuthCode, it isn't required to call that every time before getting AuthCode,
/// but frequency of minimum calls is not known as well.
@available(iOS 13, *)
final class UpdateCookiesOperation: AsyncOperation {
  let email: String
  let password: String
    
  @Storage<CSRFToken?>(key: "csrf", defaultValue: nil)
  var token: CSRFToken?
  
  @Storage<AuthCode?>(key: "authCode", defaultValue: nil)
  var authCode: AuthCode?
  
  init(email: String, password: String) {
    self.email = email
    self.password = password
    super.init()
  }
  
  override func main() {
    state = .executing
    guard authCode == nil else {
        print("Cookies: Got already an auth code, skipping to getting access token.")
        state = .finished
        return
    }
    
    guard let csrfToken = token else {
        print("Cookies: Wasn't able to get token from previous operation")
        state = .finished
        return
    }
    
      guard let request = try? createRequest(token: csrfToken) else { preconditionFailure() }
      URLSession.shared.dataTask(with: request).resume()
  }
  
  private func createRequest(token: CSRFToken) throws -> URLRequest {
    let librusLoginURL =
      URL(string:"https://portal.librus.pl/rodzina/login/action")!
    
    var request = URLRequest(url: librusLoginURL)
    
    let body = [
      "email": email,
      "password": password
    ]
    
    guard let bodyData = try? JSONEncoder.shared.encode(body) else { preconditionFailure("Encoding mail and password to data failed.") }
    request.httpBody = bodyData
    
    request.httpMethod = "POST"
    request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    request.addValue(token.token, forHTTPHeaderField: "X-CSRF-TOKEN")
    
    return request
  }
  
  override func start() {
    main()
  }
}
