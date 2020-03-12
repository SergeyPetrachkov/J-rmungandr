//
//  File.swift
//  
//
//  Created by Сергей Петрачков on 02.03.2020.
//

import Foundation
import UIKit

public enum ModuleError: Error {
	case busy
	case internalError(details: String)
	case undefined
}

public protocol CollectionPresenterInput: AnyObject {
	func fetchItems(reset: Bool) throws
}

public protocol CollectionViewModel {
	var pendingState: PendingState? { get set }
	var batchSize: Int { get set }
	var items: [CollectionItemPresenter] { get set }
	var changeSet: [CollectionDelta] { get set }
}

public extension CollectionViewModel {
	var isBusy: Bool {
		return self.pendingState != nil
	}
}

open class CollectionPresenter: CollectionPresenterInput, Pendable, CollectionSource {

	public var collectionModel: CollectionViewModel

	public var pendableModel: Pendable?

	public weak var pendableDelegate: PendableDelegate?

	public init(collectionModel: CollectionViewModel) {
		self.collectionModel = collectionModel
	}

	open func fetchItems(reset: Bool) throws {
		if self.collectionModel.isBusy {
			throw ModuleError.busy
		}
		self.performPrefetch(reset: reset)
	}

	open func performPrefetch(reset: Bool)  {
		if reset {
			self.collectionModel.changeSet = self.collectionModel
				.items
				.enumerated()
				.map { .delete(IndexPath(row: $0.offset, section: 0)) }
		}
	}

	// MARK: - Pendable
	open func enterPendingState(_ state: PendingState) {
		self.collectionModel.pendingState = state
	}

	open func exitPendingState() {
		self.collectionModel.pendingState = nil
		self.collectionModel.changeSet = []
	}

	// MARK: - CollectionSource
	open func modelForSectionHeader(at index: Int) -> CollectionItemPresenter? {
		return nil
	}

	open func heightForSectionHeader(at index: Int) -> CGFloat {
		return 0
	}

	open func modelForSectionFooter(at index: Int) -> CollectionItemPresenter? {
		return nil
	}

	open func heightForSectionFooter(at index: Int) -> CGFloat {
		return 0
	}

	open func modelForSection(at index: Int) -> CollectionItemPresenter? {
		return nil
	}

	open func numberOfSections() -> Int {
		return 1
	}

	open var items: [CollectionItemPresenter] {
		return self.collectionModel.items
	}

	open var changeSet: [CollectionDelta] {
		return self.collectionModel.changeSet
	}

	open func item(for indexPath: IndexPath) -> CollectionItemPresenter? {
		if indexPath.row >= self.items.count {
			return nil
		}
		return self.items[indexPath.row]
	}

	open func numberOfItems(in section: Int) -> Int {
		return self.items.count
	}
}
