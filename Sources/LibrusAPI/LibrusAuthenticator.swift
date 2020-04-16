//
//  LibrusCombine.swift
//  ddd
//
//  Created by Oskar on 19/02/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation
import SwiftSoup

class LibrusAuthenticator: NSObject {
  private var session: URLSession!
  
  var semaphore = DispatchSemaphore(value: 1)
  
  @Storage<CSRFToken?>(key: "csrf", defaultValue: nil)
  private var csrfToken: CSRFToken?
  
  @Storage<AuthCode?>(key: "auth", defaultValue: nil)
  private var authCode: AuthCode?
  
  @Storage<AccessToken?>(key: "accessToken", defaultValue: nil)
  private var accessToken: AccessToken?
  
  private(set) var email: String?
  private(set) var password: String?
  
  init(email: String, password: String) {
    super.init()
    self.email = email
    self.password = password
    
    let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    self.session = session
    
    verificationProcess()
  }
  
  // Calling to too often causes problems with getting it.
  // TODO: - Implement Date checking before requesting for new token
  func getNewCSRFToken() {
    semaphore.wait()
    var request = URLRequest(url: URL(string: "https://portal.librus.pl/oauth2/authorize?client_id=6XPsKf10LPz1nxgHQLcvZ1KM48DYzlBAhxipaXY8&redirect_uri=http://localhost/bar&response_type=code")!)
    request.httpMethod = "GET"
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    
    session.dataTask(with: request) { data, response, error in
      if let error = error {
        // TODO: Error to handle
        print(error)
      }
      if let data = data,
        let html = String(data: data, encoding: .utf8),
        let doc = try? SwiftSoup.parse(html) as Document,
        let csrf = try? doc.head()?.child(4).attr("content") {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.csrfToken = CSRFToken(key: csrf)
          self.semaphore.signal()
        }
      }
    }
    .resume()
  }
  
  func createRequest() throws -> URLRequest {
    guard let email = email,
      let password = password else {
        throw APIError.noCredentials
    }
    
    let librusLoginURL =
      URL(string:"https://portal.librus.pl/rodzina/login/action")!
    
    var request = URLRequest(url: librusLoginURL)
    
    let body = [
      "email": email,
      "password": password
    ]
    
    guard let bodyData = try? JSONEncoder.shared.encode(body) else { preconditionFailure("Encoding mail and password to data failed.") }
    request.httpBody = bodyData
    
    guard let token = csrfToken else { preconditionFailure("CSRF Token is not set!") }
    request.httpMethod = "POST"
    request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    request.addValue(token.key, forHTTPHeaderField: "X-CSRF-TOKEN")
    
    return request
  }
  
  
  /// Cookies are needed to successfully get AuthCode, it isn't required to call that every time before getting AuthCode,
  /// but frequency of minimum calls is not known as well.
  func updateCookies() {
    semaphore.wait()
    guard let request = try? createRequest() else { preconditionFailure() }
    
    URLSession.shared.dataTask(with: request) { _, _, error in
      self.semaphore.signal()
      // TODO: - Handle error
    }
    .resume()
  }
  
  /// Calls request to librus server, which will make few redirections, where one of URLs will be
  /// localhost URL with code in itself. To get that code we need to catch that url right before
  /// call to that URL will happen and it is handled in extension of that class with
  /// conformance to URLSessionTaskDelegate.
  func beginAcquiringAuthCode() {
    semaphore.wait()
    let url = URL(string: "https://portal.librus.pl/ouath2/authorize?client_id=wmSyUMo8llDAs4y9tJVYY92oyZ6h4lAt7KCuy0Gv&redirect_uri=http://localhost/bar&response_type=code")!
    
    var request = URLRequest(url: url)
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    
    session.dataTask(with: request) { _, _, error in
      defer { self.semaphore.signal() }
      if let error = error {
        // TODO: - Handle error
        print(error.localizedDescription)
        return
      }
    }
    .resume()
  }
  
  /// Access token is last token we need to get all Synergia accounts.
  /// For further informations, go to `AccessToken` definition.
  private func getAccessToken() {
    semaphore.wait()
    guard let authCode = authCode else { preconditionFailure() }
    let url = URL(string: "https://portal.librus.pl/oauth2/access_token")!
    var request = URLRequest(url: url)
    
    let body = [
      "client_id": "6XPsKf10LPz1nxgHQLcvZ1KM48DYzlBAhxipaXY8",
      "grant_type": "authorization_code",
      "code": authCode.key,
      "redirect_uri": "http://localhost/bar"
      ].queryParameters
    
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = body.data(using: .utf8, allowLossyConversion: true)
    
    session.dataTask(with: request) { [weak self] data, response, error in
      guard let self = self else { return }
      defer { self.semaphore.signal() }
      if let error = error {
        print(error)
        return
      }
      
      guard let data = data else { return }
      
      DispatchQueue.main.async {
        if let token = try? JSONDecoder.shared.decode(AccessToken.self, from: data) {
          print(token)
        }
      }
    }
    .resume()
  }
  
  /// Initial process of getting all Synergia's IDs.
  /// Mainly for debugging process, to be considered if needed
  /// in production state.
  private func verificationProcess() {
    DispatchQueue.global(qos: .utility).async {
      self.getNewCSRFToken()
      self.updateCookies()
      self.beginAcquiringAuthCode()
      self.getAccessToken()
    }
  }
  
  internal func pass(_ authCode: AuthCode) {
    self.authCode = authCode
  }
}






