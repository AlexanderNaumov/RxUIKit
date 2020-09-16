//
//  RxPageViewControllerDataSourceProxy.swift
//
//
//  Created by Alexander Naumov on 30/09/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIPageViewController: HasDataSource {
    public typealias DataSource = UIPageViewControllerDataSource
}

private let pageViewControllerDataSourceNotSet = PageViewControllerViewDataSourceNotSet()

private class PageViewControllerViewDataSourceNotSet: NSObject, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}

open class RxPageViewControllerDataSourceProxy: DelegateProxy<UIPageViewController, UIPageViewControllerDataSource>, DelegateProxyType, UIPageViewControllerDataSource {

    public weak private(set) var pageViewController: UIPageViewController?

    public init(pageViewController: ParentObject) {
        self.pageViewController = pageViewController
        super.init(parentObject: pageViewController, delegateProxy: RxPageViewControllerDataSourceProxy.self)
    }

    public static func registerKnownImplementations() {
        register { RxPageViewControllerDataSourceProxy(pageViewController: $0) }
    }

    private weak var _requiredMethodsDataSource: UIPageViewControllerDataSource? = pageViewControllerDataSourceNotSet

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return (_requiredMethodsDataSource ?? pageViewControllerDataSourceNotSet).pageViewController(pageViewController, viewControllerBefore: viewController)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return (_requiredMethodsDataSource ?? pageViewControllerDataSourceNotSet).pageViewController(pageViewController, viewControllerAfter: viewController)
    }

    open override func setForwardToDelegate(_ forwardToDelegate: UIPageViewControllerDataSource?, retainDelegate: Bool) {
        _requiredMethodsDataSource = forwardToDelegate ?? pageViewControllerDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
}
