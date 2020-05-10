//
//  CustomSessionDelegate.swift
//  LibrusAPI
//
//  Created by Oskar on 16/04/2020.
//

import Foundation

protocol AuthCodeProxy {
  func didReceive(code: AuthCode)
}

/// Catches http (not https) calls, which are forbidden by default in iOS apps, instead of executing it,
/// that method catches the code contained in URL of the request and passes it the delegate.
class CustomSessionDelegate: NSObject, URLSessionTaskDelegate {
  var delegate: AuthCodeProxy? = nil
  
  func urlSession(_ session: URLSession,
                  task: URLSessionTask,
                  willPerformHTTPRedirection response: HTTPURLResponse,
                  newRequest request: URLRequest,
                  completionHandler: @escaping (URLRequest?) -> Void) {
      if request.url!.absoluteString.starts(with: "http://localhost/bar?code=") {
        guard let stringURL = request.url?.absoluteString,
          let code = self.cutCodeFrom(string: stringURL)  else { return }
        print("Retrieving code from http url.")
        self.delegate?.didReceive(code: AuthCode(token: code))
        
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
