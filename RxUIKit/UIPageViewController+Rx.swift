//
//  UIPageViewController+rx.swift
//
//
//  Created by Alexander Naumov on 26.09.2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIPageViewController {
    
    public var setViewController: ControlEvent<(at: Int, direction: UIPageViewController.NavigationDirection, animated: Bool)> {
        let source = self.methodInvoked(#selector(Base.setViewController(at:direction:animated:))).map {
            a -> (at: Int, direction: UIPageViewController.NavigationDirection, animated: Bool) in
            let index = try castOrThrow(Int.self, a[0])
            let direction = UIPageViewController.NavigationDirection(rawValue: try castOrThrow(Int.self, a[1]))!
            let animated = try castOrThrow(Bool.self, a[2])
            return (index, direction, animated)
        }
        return ControlEvent(events: source)
    }
    
    public var delegate: DelegateProxy<UIPageViewController, UIPageViewControllerDelegate> {
        return RxPageViewControllerDelegateProxy.proxy(for: base)
    }
    
    public var didFinishAnimating: ControlEvent<(finished: Bool, previousViewControllers: [UIViewController], completed: Bool)> {
        let source = delegate.methodInvoked(#selector(UIPageViewControllerDelegate.pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:))).map { a -> (finished: Bool, previousViewControllers: [UIViewController], completed: Bool) in
            let finished = try castOrThrow(Bool.self, a[1])
            let previousViewControllers = try castOrThrow([UIViewController].self, a[2])
            let completed = try castOrThrow(Bool.self, a[3])
            return (finished, previousViewControllers, completed)
        }
        return ControlEvent(events: source)
    }
    
    public func pages<O: ObservableType, DataSource: RxPageViewControllerDataSourceType & UIPageViewControllerDataSource>
        (dataSource: DataSource)
        -> (_ source: O)
        -> Disposable
        where O.E == DataSource.Element {
        _ = base.rx.setViewController.takeUntil(base.rx.deallocated).bind { [weak vc = base] params in
            guard let vc = vc else { return }
            dataSource.pageViewController(vc, setViewControllerAt: params.at, direction: params.direction, animated: params.animated)
        }
        return { source in
            return source.subscribeProxyDataSource(ofObject: self.base, dataSource: dataSource, retainDataSource: true, binding: {
                [weak vc = self.base] (_ : RxPageViewControllerDataSourceProxy, event) in
                guard let vc = vc else { return }
                dataSource.pageViewController(vc, observedEvent: event)
            })
        }
    }
    
    public func pages<S: Sequence, O: ObservableType>()
        -> (_ source: O)
        -> (_ configureController: @escaping (Int, S.Element) -> UIViewController)
        -> Disposable
        where O.E == S {
            return { source in
                return { configureController in
                    let dataSource = RxPageViewControllerArrayDataSource<S> { _, i, item in
                        return configureController(i, item)
                    }
                    return self.pages(dataSource: dataSource)(source)
                }
            }
    }
    
    public func loopPages<S: Sequence, O: ObservableType>()
        -> (_ source: O)
        -> (_ configureController: @escaping (Int, S.Element) -> UIViewController)
        -> Disposable
        where O.E == S {
            return { source in
                return { configureController in
                    let dataSource = RxPageViewControllerLoopDataSource<S> { _, i, item in
                        return configureController(i, item)
                    }
                    return self.pages(dataSource: dataSource)(source)
                }
            }
    }
}

extension UIPageViewController {
    
    private class IndexContainer: NSObject, NSCopying {
        let index: Int
        init(index: Int) {
            self.index = index
            super.init()
        }
        func copy(with zone: NSZone? = nil) -> Any {
            return IndexContainer(index: index)
        }
    }
    
    private struct AssociatedKeys {
        static var controllers: UInt8 = 54
    }
    
    private var _controllers: NSMapTable<IndexContainer, UIViewController>? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.controllers) as? NSMapTable<IndexContainer, UIViewController> }
        set { objc_setAssociatedObject(self, &AssociatedKeys.controllers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public func set(controller: UIViewController, at index: Int) {
        if _controllers == nil { _controllers = NSMapTable.strongToWeakObjects() }
        _controllers!.setObject(controller, forKey: IndexContainer(index: index))
    }
    
    public func index(of viewController: UIViewController) -> Int? {
        let controllers = _controllers?.dictionaryRepresentation() as? [IndexContainer: UIViewController]
        return controllers?.first { $0.value == viewController }?.key.index
    }
    
    public var firstIndex: Int? {
        return viewControllers?.first.flatMap(index)
    }
    
    @objc public func setViewController(at index: Int, direction: UIPageViewController.NavigationDirection = .forward, animated: Bool = false) {}
}
