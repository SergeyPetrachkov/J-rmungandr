//
//  Pendable.swift
//  
//
//  Created by Sergey Petrachkov on 18.11.2019.
//

public protocol Pendable: AnyObject {
  func enterPendingState(_ state: PendingState)
  func exitPendingState()
}
