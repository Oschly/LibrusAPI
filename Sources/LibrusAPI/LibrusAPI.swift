//
//  LibrusCombine.swift
//  ddd
//
//  Created by Oskar on 19/02/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation
import SwiftSoup

class LibrusAPI: NSObject {
  
  private var session: URLSession!
  
  var semaphore = DispatchSemaphore(value: 1)
  
  private var csrfToken: CSRFToken?
  private var authCode: AuthCode?
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
  
  func getNewCSRFToken() {
    semaphore.wait()
    var request = URLRequest(url: URL(string: "https://portal.librus.pl/oauth2/authorize?client_id=6XPsKf10LPz1nxgHQLcvZ1KM48DYzlBAhxipaXY8&redirect_uri=http://localhost/bar&response_type=code")!)
    request.httpMethod = "GET"
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    
    session.dataTask(with: request) { data, response, error in
      if let error = error {
        // TODO: Error to handle
        print(error)
        return
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
    
    do {
      let body = try JSONSerialization.data(withJSONObject: body, options: [])
      request.httpBody = body
    } catch {
      print(error)
    }
    
    if let token = csrfToken {
      request.httpMethod = "POST"
      request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
      request.addValue(token.key, forHTTPHeaderField: "X-CSRF-TOKEN")
    }    
    return request
  }
  
  func updateCookies() {
    semaphore.wait()
    guard let request = try? createRequest() else {
      preconditionFailure()
    }
    
    URLSession.shared.dataTask(with: request) { _, _, error in
      defer { self.semaphore.signal() }
      // TODO: - Handle error
    }
  }
  
  func getAuthCode() {
    semaphore.wait()
    let url = URL(string: "https://portal.librus.pl/ouath2/authorize?client_id=wmSyUMo8llDAs4y9tJVYY92oyZ6h4lAt7KCuy0Gv&redirect_uri=http://localhost/bar&response_type=code")!
    
    var request = URLRequest(url: url)
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    
    session.dataTask(with: request) { _, _, error in
      defer { self.semaphore.signal() }
      if let error = error {
        print(error.localizedDescription)
        return
      }
    }
    .resume()
  }
  
  private func verificationProcess() {
    DispatchQueue.global(qos: .utility).async {
      self.getNewCSRFToken()
      self.updateCookies()
      self.getAuthCode()
    }
  }
  
  fileprivate func cutCodeFrom(string: String) -> String? {
    guard let cutEndIndex = string.firstIndex(of: "=") else { return nil }
    let startIndex = string.startIndex
    
    var code = string
    code.removeSubrange(startIndex...cutEndIndex)
    
    return code
  }
}

extension LibrusAPI: URLSessionTaskDelegate {
  func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
    if request.url!.absoluteString.starts(with: "http://localhost") {
      guard let stringURL = request.url?.absoluteString,
        let code = cutCodeFrom(string: stringURL)  else { return }
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.authCode = AuthCode(key: code)
      }
      
      task.cancel()
    }
    
    completionHandler(request)
  }
}
