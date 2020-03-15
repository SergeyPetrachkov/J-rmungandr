//
//  File.swift
//
//
//  Created by Сергей Петрачков on 02.03.2020.
//

import Foundation
import UIKit

// MARK: - Protocols
public protocol CollectionSource: AnyObject {
  var items: [CollectionItemPresenter] { get }

  var changeSet: [CollectionDelta] { get }

  func item(for indexPath: IndexPath) -> CollectionItemPresenter?
  func numberOfItems(in section: Int) -> Int
  func numberOfSections() -> Int
}

public protocol CollectionDelegate: AnyObject {
  func didSelect(item: CollectionItemPresenter,
                 at indexPath: IndexPath)
}

// MARK: - Implementations
open class TableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate {
  open private(set) var provider: CollectionSource
  open private(set) weak var delegate: CollectionDelegate?
  open private(set) weak var fetchDelegate: CollectionPresenterInput?

  public init(provider: CollectionSource, delegate: CollectionDelegate?, fetchDelegate: CollectionPresenterInput?) {
    self.provider = provider
    super.init()
    self.delegate = delegate
    self.fetchDelegate = fetchDelegate
  }

  open func numberOfSections(in tableView: UITableView) -> Int {
    return self.provider.numberOfSections()
  }

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.provider.numberOfItems(in: section)
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let model = self.provider.item(for: indexPath) {
      let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath)
      return cell
    } else {
      fatalError("An error occured while trying to access CollectionSource item at indexPath: \(indexPath)")
    }
  }

  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let model = self.provider.item(for: indexPath) {
      self.delegate?.didSelect(item: model,
                               at: indexPath)
    }

    tableView.deselectRow(at: indexPath,
                          animated: true)
  }

  open func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                      withVelocity velocity: CGPoint,
                                      targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let bottomEdge = targetContentOffset.pointee.y + scrollView.frame.size.height
    if bottomEdge >= scrollView.contentSize.height {
      _ = try? self.fetchDelegate?.fetchItems(reset: false)
    }
  }
}

open class SiberianCollectionViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  open private(set) var provider: CollectionSource
  open private(set) weak var delegate: CollectionDelegate?
  open private(set) weak var fetchDelegate: CollectionPresenterInput?

  private let scrollDirection: UICollectionView.ScrollDirection

  public init(provider: CollectionSource,
              delegate: CollectionDelegate?,
              fetchDelegate: CollectionPresenterInput?,
              scrollDirection: UICollectionView.ScrollDirection = .vertical) {
    self.provider = provider
    self.scrollDirection = scrollDirection
    super.init()
    self.delegate = delegate
    self.fetchDelegate = fetchDelegate
  }

  open var defaultCellHeight: CGFloat {
    return 44
  }

  public func collectionView(_ collectionView: UICollectionView,
                             numberOfItemsInSection section: Int) -> Int {
    return self.provider.numberOfItems(in: section)
  }

  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = self.provider.item(for: indexPath) else {
      return
    }
    self.delegate?.didSelect(item: item, at: indexPath)
    collectionView.deselectItem(at: indexPath, animated: true)
  }

  public func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let model = self.provider.item(for: indexPath) {
      let cell = collectionView.dequeueReusableCell(withModel: model, for: indexPath)
      return cell
    } else {
      fatalError("An error occured while trying to access CollectionSource item at indexPath:\(indexPath)")
    }
  }

  open func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: self.defaultCellHeight)
  }

  open func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                      withVelocity velocity: CGPoint,
                                      targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let edge = self.scrollDirection == .horizontal
      ? targetContentOffset.pointee.x + scrollView.frame.size.width
      : targetContentOffset.pointee.y + scrollView.frame.size.height
    let contentDimension = self.scrollDirection == .horizontal
      ? scrollView.contentSize.width
      : scrollView.contentSize.height
    if edge >= contentDimension {
      _ = try? self.fetchDelegate?.fetchItems(reset: false)
    }
  }
}

