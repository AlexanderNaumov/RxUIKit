//
//  RxSectionedItem.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 07/12/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import Foundation

public struct RxSectionedItem<C: Collection>: RxSectionedItemType, Sequence, Collection where C.Index == Int {
    public let title: String
    public let items: C
    public init(title: String, items: C) { self.title = title; self.items = items }
    
    public func index(after i: Int) -> Int {
        return items.index(after: i)
    }
    public subscript(position: Int) -> C.Element {
        return items[position]
    }
    public var startIndex: Int {
        return items.startIndex
    }
    public var endIndex: Int {
        return items.endIndex
    }
}
