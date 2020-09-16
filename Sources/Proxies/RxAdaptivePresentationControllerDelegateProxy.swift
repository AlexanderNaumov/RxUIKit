//
//  RxAdaptivePresentationControllerDelegateProxy.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 15/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIPresentationController: HasDelegate {
    public typealias Delegate = UIAdaptivePresentationControllerDelegate
}

open class RxAdaptivePresentationControllerDelegateProxy: DelegateProxy<UIPresentationController, UIAdaptivePresentationControllerDelegate>, DelegateProxyType, UIAdaptivePresentationControllerDelegate {
    
    public weak private(set) var presentationController: UIPresentationController?
    
    public init(presentationController: ParentObject) {
        self.presentationController = presentationController
        super.init(parentObject: presentationController, delegateProxy: RxAdaptivePresentationControllerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        register { RxAdaptivePresentationControllerDelegateProxy(presentationController: $0) }
    }
}
