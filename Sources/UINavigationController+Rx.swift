//
//  UINavigationController+Rx.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 05/12/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MultipleDelegate

extension Reactive where Base: UINavigationController {
    public func setDelegate(_ delegate: UINavigationControllerDelegate) -> Disposable {
        return RxNavigationControllerDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
    }
    
    public func setRetainDelegate(_ delegate: UINavigationControllerDelegate) -> Disposable {
        return RxNavigationControllerDelegateProxy.installForwardDelegate(delegate, retainDelegate: true, onProxyForObject: base)
    }
    public func setRetainDelegates(_ delegates: [UINavigationControllerDelegate]) -> Disposable {
        let delegate = MultipleDelegate<UINavigationControllerDelegate>()!
        delegates.forEach(delegate.addDelegate)
        return setRetainDelegate(delegate.delegate)
    }
}
