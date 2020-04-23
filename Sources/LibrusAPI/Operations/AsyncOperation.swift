//
//  AsyncOperation.swift
//  LibrusAPI
//
//  Created by Oskar on 22/04/2020.
//

import Foundation

class AsyncOperation: Operation {
  enum State: String {
    typealias RawValue = String
    
    case ready, executing, finished
    
    fileprivate var keyPath: String {
      return "is\(rawValue.capitalized)"
    }
  }
  
  var state = State.ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }
  
  override var isReady: Bool {
    return super.isReady && state == .ready
  }
  
  override var isExecuting: Bool {
    return state == .executing
  }
  
  override var isFinished: Bool {
    return state == .finished
  }
  
  override var isAsynchronous: Bool {
    return true
  }
  
  override func start() {
    main()
    state = .executing
  }
}
