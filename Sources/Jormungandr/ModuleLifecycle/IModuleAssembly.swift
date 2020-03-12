//
//  File.swift
//  
//
//  Created by Сергей Петрачков on 10.03.2020.
//

import Foundation

public protocol IModuleAssembly {
	associatedtype ModuleIn
	associatedtype View
	associatedtype Presenter
	associatedtype Interactor
	associatedtype Router

	func createModule(moduleIn: ModuleIn) -> View

	func injectPresenter(moduleIn: ModuleIn) -> Presenter

	func injectInteractor() -> Interactor

	func injectRouter() -> Router
}
