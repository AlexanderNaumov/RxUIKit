//
//  DelegateProxyType.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 15/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import RxCocoa
import RxSwift

public protocol HasTransitioningDelegate: AnyObject {
    associatedtype TransitioningDelegate
    var transitioningDelegate: TransitioningDelegate? { get set }
}

extension DelegateProxyType where ParentObject: HasTransitioningDelegate, Self.Delegate == ParentObject.TransitioningDelegate {
    public static func currentDelegate(for object: ParentObject) -> Delegate? {
        return object.transitioningDelegate
    }
    
    public static func setCurrentDelegate(_ delegate: Delegate?, to object: ParentObject) {
        object.transitioningDelegate = delegate
    }
}
