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
    public func eventItems<S: Sequence, Cell: UITableViewCell, O: ObservableType>
        (cellIdentifier: String, cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Element, Cell) -> Void)
        -> Disposable
        where O.E == RxTableEventContainer<S> {
            return { source in
                return { configureCell in
                    let dataSource = RxTableViewDataSource<S> { (tv, i, item) in
                        let cell = tv.dequeueReusableCell(withIdentifier: cellIdentifier, for: IndexPath(row: i, section: 0)) as! Cell
                        configureCell(i, item, cell)
                        return cell
                    }
                    return self.items(dataSource: dataSource)(source)
                }
            }
    }
    
    public func staticCells<O: ObservableType, V: Any>()
        -> (_ source: O)
        -> (_ newCell: @escaping (IndexPath, V) -> UITableViewCell)
        -> Disposable
        where O.E == ([[Int]], V) {
            return { source in
                return { newCell in
                    let dataSource = RxTableViewStaticDataSource<V> { (_, i, v) in
                        newCell(i, v)
                    }
                    return self.items(dataSource: dataSource)(source)
                }
            }
    }
}
