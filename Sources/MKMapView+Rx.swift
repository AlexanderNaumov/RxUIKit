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
import MultipleDelegate

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
    
    public func setRetainDelegates(_ delegates: [MKMapViewDelegate]) -> Disposable {
        let delegate = MultipleDelegate<MKMapViewDelegate>()!
        delegates.forEach(delegate.addDelegate)
        return setRetainDelegate(delegate.delegate)
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
    
    public var didChangeUserTrackingMode: ControlEvent<(mode: MKUserTrackingMode, animated: Bool)> {
        let source = delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:didChange:animated:))).map {
            return (mode: MKUserTrackingMode(rawValue: try castOrThrow(Int.self, $0[1]))!, animated: try castOrThrow(Bool.self, $0[2]))
        }
        return ControlEvent(events: source)
    }
    
    public var didAddAnnotationViews: ControlEvent<[MKAnnotationView]> {
        let source = delegate.methodInvoked(#selector((MKMapViewDelegate.mapView(_:didAdd:))! as (MKMapViewDelegate) -> (MKMapView, [MKAnnotationView]) -> Void)).map { a in
            return try castOrThrow([MKAnnotationView].self, a[1])
        }
        return ControlEvent(events: source)
    }
    
    public var isUserLocationVisible: Binder<Bool> {
        return Binder(base) { control, value in
            control.showsUserLocation = value
        }
    }
}
