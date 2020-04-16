//
//  LibrusAuthenticator+URLSessionTaskDelegate.swift
//  LibrusAPI
//
//  Created by Oskar on 16/04/2020.
//

import Foundation

extension LibrusAuthenticator: URLSessionTaskDelegate {
  func urlSession(_ session: URLSession,
                  task: URLSessionTask,
                  willPerformHTTPRedirection response: HTTPURLResponse,
                  newRequest request: URLRequest,
                  completionHandler: @escaping (URLRequest?) -> Void) {
    if request.url!.absoluteString.starts(with: "http://localhost/bar?code=") {
      guard let stringURL = request.url?.absoluteString,
        let code = cutCodeFrom(string: stringURL)  else { return }
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.pass(AuthCode(key: code))
      }
      
      task.cancel()
      completionHandler(nil)
      return
    }
    completionHandler(request)
  }
  
  private func cutCodeFrom(string: String) -> String? {
    guard let cutEndIndex = string.firstIndex(of: "=") else { return nil }
    let startIndex = string.startIndex
    
    var code = string
    code.removeSubrange(startIndex...cutEndIndex)
    
    return code
  }
}
