//
//  RxTextFieldDelegateProxy.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 15/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITextField: HasDelegate {
    public typealias Delegate = UITextFieldDelegate
}

open class RxTextFieldDelegateProxy: DelegateProxy<UITextField, UITextFieldDelegate>, DelegateProxyType, UITextFieldDelegate {
    
    public weak private(set) var textField: UITextField?
    
    public init(textField: ParentObject) {
        self.textField = textField
        super.init(parentObject: textField, delegateProxy: RxTextFieldDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        register { RxTextFieldDelegateProxy(textField: $0) }
    }
}
