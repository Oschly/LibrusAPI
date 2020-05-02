//
//  CSRFTokenOperation.swift
//  LibrusAPI
//
//  Created by Oskar on 22/04/2020.
//

import Foundation
import SwiftSoup

final class CSRFTokenOperation: AsyncOperation {
  let session: URLSession
  let urlSessionDelegate = CustomSessionDelegate()
  
  lazy var semaphore = DispatchSemaphore(value: 0)
  
  @Storage<CSRFToken?>(key: "csrf", defaultValue: nil)
  var token: CSRFToken?
  
  @Storage<AuthCode?>(key: "authCode", defaultValue: nil)
  var authCode: AuthCode?
  
  var error: Error?
  
  override init() {
    let session = URLSession(configuration: .default, delegate: urlSessionDelegate, delegateQueue: nil)
    self.session = session
    
    super.init()
    urlSessionDelegate.delegate = self
  }
  
  override func main() {
    authCode = nil
    state = .executing
    
    guard authCode == nil else {
      print("CSRF: AuthCode is already present, skipping operation.")
      state = .finished
      return
    }
    
    // Tokens' validation is done in @Storage wrapper's getter.
    guard token == nil else {
      print("CSRF: token already exists, waiting for http redirection...")
        semaphore.wait()
        return
    }
    
    var request = URLRequest(url: URL(string: "https://portal.librus.pl/oauth2/authorize?client_id=6XPsKf10LPz1nxgHQLcvZ1KM48DYzlBAhxipaXY8&redirect_uri=http://localhost/bar&response_type=code")!)
    request.httpMethod = "GET"
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    
    session.dataTask(with: request) { [weak self] data, response, error in
      if let error = error as? URLError {
        // TODO: - Handle errors
        if error.code == .cancelled {
          print("CSRF: Session has been cancelled by code, probably it's fine. Continuing.")
          self?.state = .finished
          return
        }
      }
      
      if let data = data,
        let html = String(data: data, encoding: .utf8),
        let doc = try? SwiftSoup.parse(html) as Document,
        let csrf = try? doc.head()?.child(4).attr("content") {
        
        guard let self = self else { return }
        print("CSRF: Retrieved csrf token, assigning for later use.")
        self.token = CSRFToken(token: csrf)
        self.state = .finished
      }
    }
    .resume()
  }
  
  override func start() {
    main()
  }
}

extension CSRFTokenOperation: AuthCodeProxy {
  func didReceive(code: AuthCode) {
    DispatchQueue.main.async {
      defer { self.semaphore.signal() }
      guard self.state != .finished else { return }
      print("CSRF: Got http redirection, processing code.")
      self.authCode = code
      self.state = .finished
    }
  }
}
