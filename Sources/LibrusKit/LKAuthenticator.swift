//
//  LKAuthenticator.swift
//  ddd
//
//  Created by Oskar on 19/02/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation

protocol TokenRefresher {
  func refreshAccessToken(token: String, login: String)
}

public class LKAuthenticator {
  static let instance = LKAuthenticator()
  
  fileprivate let loginQueue: OperationQueue = {
    let queue = OperationQueue()
    
    queue.underlyingQueue = DispatchQueue.global(qos: .userInitiated)
    queue.maxConcurrentOperationCount = 1
    
    return queue
  }()
  
  private var loginCompletion: ((Result<LKAccountsList, Error>) -> ())? = nil
  
  public func getAccountsList(email: String, password: String, _ completion: @escaping (Result<LKAccountsList, Error>) -> ()) throws {
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

extension LKAuthenticator: TokenRefresher {
  func refreshAccessToken(token: String, login: String) {
    let refreshOp = RefreshTokenOperation(token: token, login: login)
    let accountsListOp = AccountsListOperation()
    
    accountsListOp.completion = loginCompletion
    
    loginQueue.addOperations([refreshOp, accountsListOp],
                             waitUntilFinished: false)
  }
}


