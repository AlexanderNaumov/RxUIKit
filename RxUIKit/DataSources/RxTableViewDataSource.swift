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

open class RxTableViewCollectionDataSource<C: Collection, E>: NSObject, RxTableViewDataSourceType where C.Index == Int {
    
    internal var items: C!
    
    typealias CellFactory = (UITableView, IndexPath, E) -> UITableViewCell
    
    let cellFactory: CellFactory
    
    init(cellFactory: @escaping CellFactory) {
        self.cellFactory = cellFactory
    }
    
    public func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<RxCollectionEventContainer<C>>) {
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
    
    private var cells: [[UITableViewCell]] = []
    
    typealias CellsFactory = (V) -> [[UITableViewCell]]
    
    let cellsFactory: CellsFactory
    
    init(cellsFactory: @escaping CellsFactory) {
        self.cellsFactory = cellsFactory
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, observedEvent: Event<V>) {
        Binder(self) { `self`, value in
            self.cells = self.cellsFactory(value)
            tableView.reloadData()
            }.on(observedEvent)
    }
}
