//
//  UITableView+Rx.swift
//
//
//  Created by Alexander Naumov on 17/10/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    public func eventItems<C: Collection, Cell: UITableViewCell, O: ObservableType>
        (cellIdentifier: String, cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (IndexPath, C.Element, Cell) -> Void)
        -> Disposable
        where C.Index == Int, O.E == RxCollectionEventContainer<C> {
            return { source in
                return { configureCell in
                    let dataSource = RxTableViewDataSource<C> { (tv, i, item) in
                        let cell = tv.dequeueReusableCell(withIdentifier: cellIdentifier, for: i) as! Cell
                        configureCell(i, item, cell)
                        return cell
                    }
                    return self.items(dataSource: dataSource)(source)
                }
            }
    }
    
    public func sectionedItems<C: Collection, Cell: UITableViewCell, O: ObservableType>
        (cellIdentifier: String, cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (IndexPath, C.Element.Element, Cell) -> Void)
        -> Disposable
        where C.Index == Int, C.Element: Collection, C.Element.Index == Int, O.E == RxCollectionEventContainer<C> {
            return { source in
                return { configureCell in
                    let dataSource = RxTableViewSectionedDataSource<C> { (tv, i, item) in
                        let cell = tv.dequeueReusableCell(withIdentifier: cellIdentifier, for: i) as! Cell
                        configureCell(i, item, cell)
                        return cell
                    }
                    return self.items(dataSource: dataSource)(source)
                }
            }
    }
    
    public func sectionedItems<C: Collection, O: ObservableType>()
        -> (_ source: O)
        -> (_ makeCell: @escaping (IndexPath, C.Element.Element, (String) -> UITableViewCell) -> Void)
        -> Disposable
        where C.Index == Int, C.Element: Collection, C.Element.Index == Int, O.E == RxCollectionEventContainer<C> {
            return { source in
                return { makeCell in
                    let dataSource = RxTableViewSectionedDataSource<C> { (tv, i, item) in
                        var cell: UITableViewCell!
                        makeCell(i, item, { id in
                            cell = tv.dequeueReusableCell(withIdentifier: id, for: i)
                            return cell
                        })
                        return cell
                    }
                    return self.items(dataSource: dataSource)(source)
                }
            }
    }
    
    public func staticCells<O: ObservableType>()
        -> (_ source: O)
        -> (_ newCells: @escaping (O.E) -> [[UITableViewCell]])
        -> Disposable {
            return { source in
                return { newCells in
                    let dataSource = RxTableViewStaticDataSource<O.E> {
                        newCells($0)
                    }
                    return self.items(dataSource: dataSource)(source)
                }
            }
    }
    
    public var isEditing: Binder<Bool> {
        return Binder(base) { (tableView, isEditing) in
            tableView.setEditing(isEditing, animated: true)
        }
    }
}
