//
//  ModuleLifecycle.swift
//  
//
//  Created by Sergey Petrachkov on 18.11.2019.
//

import Foundation

public protocol ModuleLifecycle: AnyObject {
  func start()
  func stop()
  func resume()
}
