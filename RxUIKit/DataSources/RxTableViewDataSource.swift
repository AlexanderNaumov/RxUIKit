//
//  RxTableViewDataSource.swift
//
//
//  Created by Alexander Naumov on 17/10/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public struct RxTableEventContainer<S: Sequence> {
    public enum RxTableViewEvent {
        case insert([Int])
        case reload
    }
    public var event: RxTableViewEvent
    public var items: S
    public init(event: RxTableViewEvent, items: S) {
        self.event = event
        self.items = items
    }
}

open class RxTableViewDataSource<S: Sequence>: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    private var items: [S.Element] = []
    
    typealias CellFactory = (UITableView, Int, S.Element) -> UITableViewCell
    
    let cellFactory: CellFactory
    
    init(cellFactory: @escaping CellFactory) {
        self.cellFactory = cellFactory
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFactory(tableView, indexPath.row, items[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<RxTableEventContainer<S>>) {
        Binder(self) { `self`, container in
            switch container.event {
            case let .insert(indexes) where !self.items.isEmpty:
                self.items = container.items as! [S.Element]
                tableView.insertRows(at: indexes.map { [0, $0] }, with: .none)
            case .reload:
                fallthrough
            default:
                self.items = container.items as! [S.Element]
                tableView.reloadData()
            }
        }.on(observedEvent)
    }
}
