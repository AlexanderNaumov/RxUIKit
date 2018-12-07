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

public struct RxTableEventContainer<C: Collection> {
    public enum RxTableViewEvent {
        case insert([IndexPath])
        case update([IndexPath])
        case reload
    }
    public var event: RxTableViewEvent
    public var items: C
    public init(event: RxTableViewEvent, items: C) {
        self.event = event
        self.items = items
    }
}

open class RxTableViewCollectionDataSource<C: Collection, E>: NSObject, RxTableViewDataSourceType where C.Index == Int {
    
    internal var items: C!
    
    typealias CellFactory = (UITableView, IndexPath, E) -> UITableViewCell
    
    let cellFactory: CellFactory
    
    init(cellFactory: @escaping CellFactory) {
        self.cellFactory = cellFactory
    }
    
    public func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<RxTableEventContainer<C>>) {
        Binder(self) { `self`, container in
            switch container.event {
            case let .insert(i) where !self.items.isEmpty:
                self.items = container.items
                tableView.insertRows(at: i, with: .none)
            case let .update(i):
                self.items = container.items
                tableView.reloadRows(at: i, with: .none)
            case .reload:
                fallthrough
            default:
                self.items = container.items
                tableView.reloadData()
            }
        }.on(observedEvent)
    }
}

open class RxTableViewDataSource<C: Collection>: RxTableViewCollectionDataSource<C, C.Element>, UITableViewDataSource where C.Index == Int {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFactory(tableView, indexPath, items[indexPath.row])
    }
}

open class RxTableViewSectionedDataSource<C: Collection>: RxTableViewCollectionDataSource<C, C.Element.Element>, UITableViewDataSource where C.Index == Int, C.Element: Collection, C.Element.Index == Int {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return items?.count ?? 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?[section].count ?? 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFactory(tableView, indexPath, items[indexPath.section][indexPath.row])
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (items as? [RxSectionedItemType])?[section].title
    }
}

open class RxTableViewStaticDataSource<V: Any>: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    private var cells: [IndexPath: UITableViewCell] = [:]
    private var value: V!
    
    typealias CellFactory = (UITableView, IndexPath, V) -> UITableViewCell
    
    let cellFactory: CellFactory
    
    private var sections: [[Int]] = []
    
    init(cellFactory: @escaping CellFactory) {
        self.cellFactory = cellFactory
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = cells[indexPath]
        if cell == nil {
            cell = cellFactory(tableView, indexPath, value)
            cells[indexPath] = cell
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<([[Int]], V)>) {
        Binder(self) { `self`, item in
            self.sections = item.0
            self.value = item.1
            self.cells.removeAll()
            tableView.reloadData()
            }.on(observedEvent)
    }
}
