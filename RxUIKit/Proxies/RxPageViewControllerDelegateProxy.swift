//
//  RxPageViewControllerDelegateProxy.swift
//
//
//  Created by Alexander Naumov on 30/09/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIPageViewController: HasDelegate {
    public typealias Delegate = UIPageViewControllerDelegate
}

open class RxPageViewControllerDelegateProxy: DelegateProxy<UIPageViewController, UIPageViewControllerDelegate>, DelegateProxyType, UIPageViewControllerDelegate {
    
    public weak private(set) var pageViewController: UIPageViewController?
    
    public init(pageViewController: ParentObject) {
        self.pageViewController = pageViewController
        super.init(parentObject: pageViewController, delegateProxy: RxPageViewControllerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        register { RxPageViewControllerDelegateProxy(pageViewController: $0) }
    }
}
