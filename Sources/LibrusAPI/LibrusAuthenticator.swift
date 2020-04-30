//
//  LibrusCombine.swift
//  ddd
//
//  Created by Oskar on 19/02/2020.
//  Copyright © 2020 Oschly. All rights reserved.
//

import Foundation

protocol TokenRefresher {
  func refreshAccessToken(token: String)
}

class LibrusAuthenticator: NSObject {
  fileprivate var opQueue = OperationQueue()
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
    
    accountsListOp.completion = { result in
      if let result = try? result.get() {
        let url = URL(string: "https://api.librus.pl/2.0/Grades")!
        var request = URLRequest(url: url)
        request.addValue("LibrusMobileApp", forHTTPHeaderField: "User-Agent")
        request.addValue("Bearer \(result.accounts[0].token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
          let grades = try! JSONDecoder.shared.decode(Grades.self, from: data!)
          let grade = grades.grades[0]
          var teacher = grade.teacher
          DispatchQueue.main.async {
          teacher = teacher.fetchedInfo(token: result.accounts[0].token)
            dump(teacher)
          }
          }
        .resume()
      
      }
    }
    
    opQueue.underlyingQueue = DispatchQueue.global(qos: .utility)
    opQueue.addOperations([acquireCsrfTokenOp, cookiesOp, authCodeOp, accessTokenOp, accountsListOp], waitUntilFinished: false)
  }
  
  @objc func refreshToken(notification: Notification) {

    //refreshOp.addDependency(operationQueue.operations[0])
    
    //operationQueue.addOperations([RefreshTokenOperation, accountsListOp], waitUntilFinished: true)
  }
}

extension LibrusAuthenticator: TokenRefresher {
  func refreshAccessToken(token: String) {
    //let refreshOp = RefreshTokenOperation(token: token)
   // let accountsListOp = AccountsListOperation(refresher: nil)
    
    
  }
  
  
}
