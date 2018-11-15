//
//  UIPresentationController+Rx.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 15/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIPresentationController {
    public var delegate: DelegateProxy<UIPresentationController, UIAdaptivePresentationControllerDelegate> {
        return RxAdaptivePresentationControllerDelegateProxy.proxy(for: base)
    }
    
    public func setDelegate(_ delegate: UIAdaptivePresentationControllerDelegate) -> Disposable {
        return RxAdaptivePresentationControllerDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
    }
    
    public func setRetainDelegate(_ delegate: UIAdaptivePresentationControllerDelegate) -> Disposable {
        return RxAdaptivePresentationControllerDelegateProxy.installForwardDelegate(delegate, retainDelegate: true, onProxyForObject: base)
    }
}
