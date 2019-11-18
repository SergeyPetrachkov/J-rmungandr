//
//  CollectionDelta.swift
//  
//
//  Created by Sergey Petrachkov on 18.11.2019.
//

import Foundation

/// Represents atomic change in a collection
public enum CollectionDelta {
  case new(IndexPath)
  case edit(IndexPath)
  case delete(IndexPath)
}
