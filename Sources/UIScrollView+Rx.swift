//
//  UIScrollView+Rx.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 14/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MultipleDelegate

extension Reactive where Base: UIScrollView {
    public func setRetainDelegate(_ delegate: UIScrollViewDelegate) -> Disposable {
        return RxScrollViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: true, onProxyForObject: base)
    }
    public func setRetainDelegates(_ delegates: [UIScrollViewDelegate]) -> Disposable {
        let delegate = MultipleDelegate<UIScrollViewDelegate>()!
        delegates.forEach(delegate.addDelegate)
        return setRetainDelegate(delegate.delegate)
    }
}
