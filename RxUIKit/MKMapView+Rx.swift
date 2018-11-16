//
//  MKMapView+Rx.swift
//  RxUIKit
//
//  Created by Alexander Naumov on 16/11/2018.
//  Copyright © 2018 Alexander Naumov. All rights reserved.
//

import MapKit
import RxCocoa
import RxSwift

extension Reactive where Base: MKMapView {
    public var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMapViewDelegateProxy.proxy(for: base)
    }
    
    public func setDelegate(_ delegate: MKMapViewDelegate) -> Disposable {
        return RxMapViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
    }
    
    public func setRetainDelegate(_ delegate: MKMapViewDelegate) -> Disposable {
        return RxMapViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: true, onProxyForObject: base)
    }
    
    public var didUpdateUserLocation: ControlEvent<MKUserLocation> {
        let source = delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:didUpdate:))).map {
            return try castOrThrow(MKUserLocation.self, $0[1])
        }
        return ControlEvent(events: source)
    }
    
    public var annotationViewCalloutAccessoryControlTapped: ControlEvent<(view: MKAnnotationView, control: UIControl)> {
        let source = delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:annotationView:calloutAccessoryControlTapped:))).map {
            return (view: try castOrThrow(MKAnnotationView.self, $0[1]), control: try castOrThrow(UIControl.self, $0[2]))
        }
        return ControlEvent(events: source)
    }
    
    public var regionDidChangeAnimated: ControlEvent<Bool> {
        let source = delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:))).map {
            return try castOrThrow(Bool.self, $0[1])
        }
        return ControlEvent(events: source)
    }
}
