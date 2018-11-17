//
//  UIWebView+Rx.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 17/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIWebView {
    public func setDelegate(_ delegate: UIWebViewDelegate) -> Disposable {
        return RxWebViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
    }
    
    public func setRetainDelegate(_ delegate: UIWebViewDelegate) -> Disposable {
        return RxWebViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: true, onProxyForObject: base)
    }
}
