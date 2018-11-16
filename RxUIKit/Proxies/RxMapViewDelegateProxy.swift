//
//  RxMapViewDelegateProxy.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 16/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import MapKit
import RxSwift
import RxCocoa

extension MKMapView: HasDelegate {
    public typealias Delegate = MKMapViewDelegate
}

class RxMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {
    
    public weak private(set) var mapView: MKMapView?
    
    public init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMapViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxMapViewDelegateProxy(mapView: $0) }
    }
}
