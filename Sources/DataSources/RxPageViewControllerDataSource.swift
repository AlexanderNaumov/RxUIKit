//
//  RxPageViewControllerDataSource.swift
//
//
//  Created by Alexander Naumov on 14/10/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class RxPageViewControllerDataSource<S: Sequence>: NSObject, UIPageViewControllerDataSource, RxPageViewControllerDataSourceType {
    
    public typealias ConfigureViewController = (
        UIPageViewController?,
        Int,
        S.Element
    ) -> UIViewController
    
    internal var items: [S.Element] = []
    internal var configureViewController: ConfigureViewController
    
    public init(configureViewController: @escaping ConfigureViewController) {
        self.configureViewController = configureViewController
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, setViewControllerAt index: PageIndex, direction: UIPageViewController.NavigationDirection, animated: Bool) {
        let vc = configureViewController(pageViewController, Int(index), items[Int(index)])
        pageViewController.set(controller: vc, at: index)
        pageViewController.setViewControllers([vc], direction: direction, animated: animated)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, observedEvent: RxSwift.Event<S>) {
        Binder(self) { `self`, items in
            self.items = items as! [S.Element]
            guard self.items.count > 0 else { return }
            self.pageViewController(pageViewController, setViewControllerAt: 0, direction: .forward, animated: false)
        }.on(observedEvent)
    }
}

open class RxPageViewControllerArrayDataSource<S: Sequence>: RxPageViewControllerDataSource<S> {
    public override func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = pageViewController.index(of: viewController), index < items.count - 1 else { return nil }
        index += 1
        let vc = configureViewController(pageViewController, Int(index), items[Int(index)])
        pageViewController.set(controller: vc, at: index)
        return vc
    }

    public override func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = pageViewController.index(of: viewController), index > 0 else { return nil }
        index -= 1
        let vc = configureViewController(pageViewController, Int(index), items[Int(index)])
        pageViewController.set(controller: vc, at: index)
        return vc
    }
}

open class RxPageViewControllerLoopDataSource<S: Sequence>: RxPageViewControllerDataSource<S> {
    public override func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = pageViewController.index(of: viewController), items.count > 1 else { return nil }
        index += 1
        if index >= items.count { index = 0 }
        let vc = configureViewController(pageViewController, Int(index), items[Int(index)])
        pageViewController.set(controller: vc, at: index)
        return vc
    }
    
    public override func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = pageViewController.index(of: viewController), items.count > 1 else { return nil }
        index -= 1
        if index < 0 { index = PageIndex(items.count - 1) }
        let vc = configureViewController(pageViewController, Int(index), items[Int(index)])
        pageViewController.set(controller: vc, at: index)
        return vc
    }
}
