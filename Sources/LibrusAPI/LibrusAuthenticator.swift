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
  
  init(email: String, password: String) {
    super.init()
    self.email = email
    self.password = password
  }
  
  /// Initial process of getting all Synergia's IDs.
  /// Mainly for debugging process, to be considered if needed
  /// in production state.
  private func startVerificationProcess(completion: @escaping (Result<AccessList, Error>) -> ()) throws {
    try acquireAccountsList(completion: completion)
  }
  
  private func acquireAccountsList(completion: @escaping (Result<AccessList, Error>) -> ()) throws {
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
}

@available(iOS 13, *)
extension LibrusAuthenticator: TokenRefresher {
  func refreshAccessToken(token: String, login: String) {
    let refreshOp = RefreshTokenOperation(token: token, login: login)
    let accountsListOp = AccountsListOperation()
    
    accountsListOp.completion = loginCompletion
    
    loginQueue.addOperations([refreshOp, accountsListOp],
                             waitUntilFinished: false)
  }
}
