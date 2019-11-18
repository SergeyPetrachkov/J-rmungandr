//
//  CollectionItemPresenter.swift
//  
//
//  Created by sergey on 18.11.2019.
//

import Foundation
import UIKit

public protocol GenericCollectionItemPresenter {
  associatedtype ViewType: UIView
  
  func setup(view: ViewType)
}

public protocol CollectionItemPresenter {
  static var anyViewType: UIView.Type { get }
  
  func setupAny(view: UIView)
}

public extension GenericCollectionItemPresenter {
  var viewAnyType: UIView.Type {
    return ViewType.self
  }

  func setupAny(view: UIView) {
    setup(view: view as! ViewType)
  }
}
