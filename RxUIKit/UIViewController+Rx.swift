//
//  UIViewController+Rx.swift
//
//
//  Created by Alexander Naumov on 26.09.2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    public var loadView: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.loadView)).map { _ in }
        return ControlEvent(events: source)
    }
    
    public var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    public var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    public var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    public var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
    public var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
    
    public var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    public var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIViewController {
    public var transitioningDelegate: DelegateProxy<UIViewController, UIViewControllerTransitioningDelegate> {
        return RxViewControllerTransitioningDelegateProxy.proxy(for: base)
    }
    
    public func setDelegate(_ delegate: UIViewControllerTransitioningDelegate) -> Disposable {
        return RxViewControllerTransitioningDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
    }
    
    public func setRetainDelegate(_ delegate: UIViewControllerTransitioningDelegate) -> Disposable {
        return RxViewControllerTransitioningDelegateProxy.installForwardDelegate(delegate, retainDelegate: true, onProxyForObject: base)
    }
    
}
