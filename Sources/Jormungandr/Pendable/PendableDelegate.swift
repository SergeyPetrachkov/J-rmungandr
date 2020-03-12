//
//  File.swift
//  
//
//  Created by Сергей Петрачков on 11.03.2020.
//

import Foundation

public protocol PendableDelegate: AnyObject {
	func didEnterPendingState(_ pendingState: PendingState)
	func didExitPendingState()
}
