//
//  RxCollectionEventContainer.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 12/12/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import Foundation

public struct RxCollectionEventContainer<C: Collection> {
    public enum RxCollectionViewEvent {
        case insert([IndexPath])
        case update([IndexPath])
        case reload
    }
    public var event: RxCollectionViewEvent
    public var items: C
    public init(event: RxCollectionViewEvent, items: C) {
        self.event = event
        self.items = items
    }
}
