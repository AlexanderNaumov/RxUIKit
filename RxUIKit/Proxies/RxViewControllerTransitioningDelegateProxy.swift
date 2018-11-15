//
//  RxViewControllerTransitioningDelegateProxy.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 15/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController: HasTransitioningDelegate {
    public typealias TransitioningDelegate = UIViewControllerTransitioningDelegate
}

open class RxViewControllerTransitioningDelegateProxy: DelegateProxy<UIViewController, UIViewControllerTransitioningDelegate>, DelegateProxyType, UIViewControllerTransitioningDelegate {
    
    public weak private(set) var viewController: UIViewController?
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(parentObject: viewController, delegateProxy: RxViewControllerTransitioningDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        register { RxViewControllerTransitioningDelegateProxy(viewController: $0) }
    }
}
