//
//  RxPageViewControllerDataSourceType.swift
//
//
//  Created by Alexander Naumov on 30/09/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import UIKit
import RxSwift

public protocol RxPageViewControllerDataSourceType {
    associatedtype Element
    func pageViewController(_ pageViewController: UIPageViewController, observedEvent: RxSwift.Event<Element>)
    func pageViewController(_ pageViewController: UIPageViewController, setViewControllerAt index: PageIndex, direction: UIPageViewController.NavigationDirection, animated: Bool)
}
