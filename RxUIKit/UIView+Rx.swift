//
//  UIView+Rx.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 05/12/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIView {
    public var didMoveToSuperview: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.didMoveToSuperview)).map { _ in }
        return ControlEvent(events: source)
    }
}
