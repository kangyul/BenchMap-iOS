//
//  NaverMapView.swift
//  BenchMap
//
//  Created by Yul Kang on 10/29/25.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct NaverMapView: UIViewRepresentable {
	@Binding var userLocation: CLLocationCoordinate2D?

	func makeCoordinator() -> Coordinator { Coordinator() }

	func makeUIView(context: Context) -> NMFNaverMapView {
		let naver = NMFNaverMapView(frame: .zero)

		naver.showCompass = true
		naver.showLocationButton = true
		naver.showZoomControls = true
		naver.showScaleBar = true

		let mapView = naver.mapView
		mapView.positionMode = .normal

		let start = userLocation ?? CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
		let initUpdate = NMFCameraUpdate(
			scrollTo: NMGLatLng(lat: start.latitude, lng: start.longitude),
			zoomTo: 14
		)
		mapView.moveCamera(initUpdate)

		return naver
	}

	func updateUIView(_ naver: NMFNaverMapView, context: Context) {
		guard !context.coordinator.didCenterOnce, let c = userLocation else { return }

		let mapView = naver.mapView
		let u = NMFCameraUpdate(
			scrollTo: NMGLatLng(lat: c.latitude, lng: c.longitude),
			zoomTo: max(mapView.cameraPosition.zoom, 14)
		)
		u.animation = .easeIn
		mapView.moveCamera(u)

		context.coordinator.didCenterOnce = true
	}

	final class Coordinator {
		var didCenterOnce = false
	}
}
