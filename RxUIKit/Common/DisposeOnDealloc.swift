//
//  DisposeOnDealloc.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 15/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import RxSwift

@objc public protocol BagExt {}

public struct DisposeOnDealloc<B: BagExt> {
    var reactive: Reactive<B>
    public init(_ reactive: Reactive<B>) { self.reactive = reactive }
}

extension Disposable {
    public func disposed<B: BagExt>(by deiniter: DisposeOnDealloc<B>) {
        deiniter.reactive.__bag.insert(self)
    }
}

private var bagAssociatedKey: UInt8 = 0

extension Reactive where Base: BagExt {
    fileprivate var __bag: DisposeBag {
        if let bag = objc_getAssociatedObject(base, &bagAssociatedKey) as? DisposeBag {
            return bag
        }
        let bag = DisposeBag()
        objc_setAssociatedObject(base, &bagAssociatedKey, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bag
    }
}

extension UIViewController: BagExt {}
extension UIView: BagExt {}
