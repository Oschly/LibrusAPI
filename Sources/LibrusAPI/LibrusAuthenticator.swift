//
//  LibrusCombine.swift
//  ddd
//
//  Created by Oskar on 19/02/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation

protocol TokenRefresher {
  func refreshAccessToken(token: String, login: String)
}

@available(iOS 13, *)
public class LibrusAuthenticator: NSObject {
  fileprivate let loginQueue: OperationQueue = {
    let queue = OperationQueue()
    
    queue.underlyingQueue = DispatchQueue.global(qos: .userInitiated)
    queue.maxConcurrentOperationCount = 1
    
    return queue
  }()
  
  private(set) var email: String?
  private(set) var password: String?
  
  private var loginCompletion: ((Result<AccessList, Error>) -> ())? = nil
  
  public init(email: String, password: String) {
    super.init()
    self.email = email
    self.password = password
  }
  
  public func getAccountsList(completion: @escaping (Result<AccessList, Error>) -> ()) throws {
    guard let email = email,
      let password = password
      else { throw APIError.noCredentials }
    
    let acquireCsrfTokenOp = CSRFTokenOperation()
    let cookiesOp = UpdateCookiesOperation(email: email, password: password)
    let authCodeOp = AcquriringAuthCodeOperation()
    let accessTokenOp = AccessTokenOperation()
    let accountsListOp = AccountsListOperation()
    
    cookiesOp.addDependency(acquireCsrfTokenOp)
    authCodeOp.addDependency(cookiesOp)
    accessTokenOp.addDependency(authCodeOp)
    accountsListOp.addDependency(accessTokenOp)
    
    accountsListOp.completion = completion
    loginCompletion = completion
    
    loginQueue.addOperations([acquireCsrfTokenOp,
                              cookiesOp,
                              authCodeOp,
                              accessTokenOp,
                              accountsListOp],
                             waitUntilFinished: false)
  }
  
  // TODO: Fix that
  public func getHomework(token: String, completion: @escaping (Result<[Homework], Error>) -> ()) {
    let url = URL(string: "https://api.librus.pl/2.0/HomeWorkAssignments")!
    
    var request = URLRequest(url: url)
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      dump(String(data: data!, encoding: .utf8))
    }
    .resume()
  }
  
  public func getEvents(token: String, completion: @escaping ((Result<[Event], Error>) -> ())) {
    let url = URL(string: "https://api.librus.pl/2.0/HomeWorks")!
    
    var request = URLRequest(url: url)
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
      }
      
      guard let data = data else { preconditionFailure() }
      
      do {
        let decoded = try JSONDecoder.shared.decode(Response<[Event]>.self, from: data)
        completion(.success(decoded.root))
      } catch {
        print(error)
      }
    }
    .resume()
  }
}

@available(iOS 13, *)
extension LibrusAuthenticator: TokenRefresher {
  public func refreshAccessToken(token: String, login: String) {
    let refreshOp = RefreshTokenOperation(token: token, login: login)
    let accountsListOp = AccountsListOperation()
    
    accountsListOp.completion = loginCompletion
    
    loginQueue.addOperations([refreshOp, accountsListOp],
                             waitUntilFinished: false)
  }
}
extension Array: DecodableFromNestedJSON where Element == Event {
  public static var codingKey: ResponseKeys = .events
}

public struct Homework {
  // TODO: Implement it.
}
