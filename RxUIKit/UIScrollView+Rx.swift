//
//  UIScrollView+Rx.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 14/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    func setRetainDelegate(_ delegate: UIScrollViewDelegate) -> Disposable {
        return RxScrollViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: true, onProxyForObject: self.base)
    }
}
