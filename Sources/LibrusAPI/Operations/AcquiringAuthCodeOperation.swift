//
//  AcquiringAuthCodeOperation.swift
//  LibrusAPI
//
//  Created by Oskar on 22/04/2020.
//

import Foundation

/// Calls request to librus server, which will make few redirections, where one of URLs will be
/// localhost URL with code in itself. To get that code we need to catch that url right before
/// call to that URL will happen and it is handled in extension of that class with
/// conformance to URLSessionTaskDelegate.
final class AcquriringAuthCodeOperation: AsyncOperation {
  let semaphore = DispatchSemaphore(value: 0)
  
  let urlSessionDelegate = CustomSessionDelegate()
  
  let session: URLSession
  
  @Storage<AuthCode?>(key: "authCode", defaultValue: nil)
  var authCode: AuthCode?
  
  override var isFinished: Bool { authCode != nil }
  
  override init() {
    let session = URLSession(configuration: .default, delegate: urlSessionDelegate, delegateQueue: nil)
    self.session = session
    
    super.init()
    urlSessionDelegate.delegate = self
  }
  
  override func main() {
    state = .executing
    guard authCode == nil else {
      print("AuthCode: Already got authCode, skipping operation.")
      state = .finished
      return
    }
    let url = URL(string: "https://portal.librus.pl/ouath2/authorize?client_id=wmSyUMo8llDAs4y9tJVYY92oyZ6h4lAt7KCuy0Gv&redirect_uri=http://localhost/bar&response_type=code")!
    
    var request = URLRequest(url: url)
    request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
    
    session.dataTask(with: request) { _, _, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      self.semaphore.wait()
    }
    .resume()
  }
  
  override func start() {
    main()
  }
}

/// When we have a valid cookies in storage, API immediately returns
/// AuthCode, which is needed on the end of all operations and that extension
/// catches that behavior.
extension AcquriringAuthCodeOperation: AuthCodeProxy {
  func didReceive(code: AuthCode) {
    DispatchQueue.main.async {
      self.authCode = code
      self.state = .finished
    }
  }
}
