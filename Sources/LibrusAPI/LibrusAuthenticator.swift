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
  private(set) var email: String?
  private(set) var password: String?
  
  init(email: String, password: String) {
    super.init()
    self.email = email
    self.password = password
    
    verificationProcess()
  }
  
  /// Initial process of getting all Synergia's IDs.
  /// Mainly for debugging process, to be considered if needed
  /// in production state.
  private func verificationProcess() {
    guard let email = email, let password = password else { preconditionFailure() }
    let opQueue = OperationQueue()
    opQueue.maxConcurrentOperationCount = 1
    
    let acquireCsrfTokenOp = CSRFTokenOperation()
    let cookiesOp = UpdateCookiesOperation(email: email, password: password)
    cookiesOp.addDependency(acquireCsrfTokenOp)
    let authCodeOp = AcquriringAuthCodeOperation()
    authCodeOp.addDependency(cookiesOp)
    let accessTokenOp = AccessTokenOperation()
    accessTokenOp.addDependency(authCodeOp)
    let accountsListOp = AccountsListOperation()
    accountsListOp.addDependency(accessTokenOp)
    
    opQueue.underlyingQueue = DispatchQueue.global(qos: .utility)
    opQueue.addOperations([acquireCsrfTokenOp, cookiesOp, authCodeOp, accessTokenOp, accountsListOp], waitUntilFinished: false)
  }
}




