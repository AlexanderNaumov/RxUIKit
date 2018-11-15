//
//  DisposeOnDealloc.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 15/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import RxSwift

public class DisposeOnDealloc {
    private var disposables: [Disposable] = []
    
    public init(_ deallocated: Observable<Void>) {
        _ = deallocated.subscribe(onDisposed: {
            self.disposables.forEach { $0.dispose() }
            self.disposables.removeAll()
        })
    }
    
    public func insert(_ disposable: Disposable) {
        disposables.append(disposable)
    }
}

extension Disposable {
    public func disposed(by deiniter: DisposeOnDealloc) {
        deiniter.insert(self)
    }
}
