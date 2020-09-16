//
//  UITextField+Rx.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 15/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MultipleDelegate

extension Reactive where Base: UITextField {
    public var delegate: DelegateProxy<UITextField, UITextFieldDelegate> {
        return RxTextFieldDelegateProxy.proxy(for: base)
    }
    
    public func setDelegate(_ delegate: UITextFieldDelegate) -> Disposable {
        return RxTextFieldDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
    }
    
    public func setRetainDelegate(_ delegate: UITextFieldDelegate) -> Disposable {
        return RxTextFieldDelegateProxy.installForwardDelegate(delegate, retainDelegate: true, onProxyForObject: base)
    }
    public func setRetainDelegates(_ delegates: [UITextFieldDelegate]) -> Disposable {
        let delegate = MultipleDelegate<UITextFieldDelegate>()!
        delegates.forEach(delegate.addDelegate)
        return setRetainDelegate(delegate.delegate)
    }
}
