//
//  LibrusCombine.swift
//  ddd
//
//  Created by Oskar on 19/02/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Combine
import Foundation
import SwiftSoup

class LibrusAPI: NSObject {
  
  private let configuration = URLSessionConfiguration.default
  private let session: URLSession = {
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    session.configuration.protocolClasses?.insert(CustomProtol.self, at: 0)
    URLProtocol.registerClass(CustomProtol.self)
    
    return session
  }()
  
  private var subscriptions = [AnyCancellable]()
  
  private var csrfToken = PassthroughSubject<CSRFToken, Error>()
  private var authCode = PassthroughSubject<AuthCode, Error>()
  private var accessToken = PassthroughSubject<AccessToken, Error>()
  
  private(set) var email: String?
  private(set) var password: String?
  
  init(email: String, password: String) {
    super.init()
    self.email = email
    self.password = password
    try! getNewCSRFToken()
    try! updateCookies()
    try! getAuthCode()
    
    accessToken.print().sink(receiveCompletion: { _ in }) { _ in }.store(in: &subscriptions)
    }
  
  func getNewCSRFToken() throws {
    var request = URLRequest(url: URL(string: "https://portal.librus.pl/oauth2/authorize?client_id=6XPsKf10LPz1nxgHQLcvZ1KM48DYzlBAhxipaXY8&redirect_uri=http://localhost/bar&response_type=code")!)
    request.httpMethod = "GET"
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    
    URLSession.shared
      .dataTaskPublisher(for: request)
      .mapError { error in APIError.connectionError }
      .tryMap { data, response in
        guard let html = String(data: data, encoding: .utf8) else {
          throw ScrappingError.errorDecodingData
        }
        guard let doc = try? SwiftSoup.parse(html) as Document else { throw ScrappingError.errorGettingAttribute }
        guard let csrf = try? doc.head()?.child(4).attr("content") else {
          throw ScrappingError.errorGettingAttribute
        }
        
        return CSRFToken(key: csrf)
    }
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { completion in
      #warning("Error to handle")
    }, receiveValue: { token in
      self.csrfToken.send(token)
    })
      .store(in: &subscriptions)
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
      request.httpMethod = "POST"
      request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
      
    } catch {
      print(error)
    }
    
    csrfToken
      .sink(receiveCompletion: { completion in
        #warning("Error to handle")
      }, receiveValue: { token in
        request.addValue(token.key, forHTTPHeaderField: "X-CSRF-TOKEN")
      })
      .store(in: &subscriptions)
    
    return request
  }
  
  func updateCookies() throws {
    guard let request = try? createRequest() else {
      throw APIError.noCredentials
    }
    
    URLSession.shared.dataTask(with: request) { _, _, error in
    }
  }
  
  func getAuthCode() throws {
    let url = URL(string: "https://portal.librus.pl/ouath2/authorize?client_id=wmSyUMo8llDAs4y9tJVYY92oyZ6h4lAt7KCuy0Gv&redirect_uri=http://localhost/bar&response_type=code")!
    
    var request = URLRequest(url: url)
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    
    session.dataTask(with: request) { _, _, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      guard let data = CustomClientProtocol.shared.data,
        var localhostUrl = String(data: data, encoding: .utf8),
        let lastUselessIndex = localhostUrl.firstIndex(of: "=") else { return }
      print(String(data: data, encoding: .utf8))
      localhostUrl.removeSubrange(localhostUrl.startIndex...lastUselessIndex)
      print(localhostUrl)
      
      DispatchQueue.main.async {
        let token = AccessToken(key: localhostUrl, creationDate: Date())
        self.accessToken.send(token)
        print(token)
      }

    }
      .resume()
  }
  
}

class CustomProtol: URLProtocol {
  override var client: URLProtocolClient? { CustomClientProtocol.shared }
  override class func canInit(with request: URLRequest) -> Bool {
    if request.url!.absoluteString.starts(with: "http://localhost") {
      return true
    }
    return false
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
  
  override func startLoading() {
    if request.url!.absoluteString.starts(with: "http://localhost") {
      let data = request.url?.absoluteString.data(using: .utf8)
      self.client?.urlProtocol(self, didLoad: data!)
      self.client?.urlProtocolDidFinishLoading(self)
    }
  }
  
  override func stopLoading() {}
}

class CustomClientProtocol: NSObject, URLProtocolClient {
  static let shared = CustomClientProtocol()
  public var data: Data?
  
  func urlProtocol(_ protocol: URLProtocol, didLoad data: Data) {
    self.data = data
  }
}

// MARK: - Junk for this case
extension CustomClientProtocol {
  func urlProtocol(_ protocol: URLProtocol, wasRedirectedTo request: URLRequest, redirectResponse: URLResponse) {}
  
  func urlProtocol(_ protocol: URLProtocol, cachedResponseIsValid cachedResponse: CachedURLResponse) {}
  
  func urlProtocol(_ protocol: URLProtocol, didReceive response: URLResponse, cacheStoragePolicy policy: URLCache.StoragePolicy) {}
  
  func urlProtocolDidFinishLoading(_ protocol: URLProtocol) {}
  
  func urlProtocol(_ protocol: URLProtocol, didFailWithError error: Error) {}
  
  func urlProtocol(_ protocol: URLProtocol, didReceive challenge: URLAuthenticationChallenge) {}
  
  func urlProtocol(_ protocol: URLProtocol, didCancel challenge: URLAuthenticationChallenge) {}
}
