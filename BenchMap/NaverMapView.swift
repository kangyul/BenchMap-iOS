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

	func makeUIView(context: Context) -> NMFNaverMapView {
		let naver = NMFNaverMapView(frame: .zero)

		naver.showCompass = true
		naver.showLocationButton = true
		naver.showZoomControls = true
		naver.showScaleBar = true

		let mapView = naver.mapView
		let initUpdate = NMFCameraUpdate(
			scrollTo: NMGLatLng(lat: 37.5665, lng: 126.9780),
			zoomTo: 14
		)
		mapView.moveCamera(initUpdate)

		mapView.positionMode = .direction

		return naver
	}

	func updateUIView(_ naver: NMFNaverMapView, context: Context) {
		if let c = userLocation {
			let mapView = naver.mapView
			let u = NMFCameraUpdate(
				scrollTo: NMGLatLng(lat: c.latitude, lng: c.longitude),
				zoomTo: max(mapView.cameraPosition.zoom, 14)
			)
			u.animation = .easeIn
			mapView.moveCamera(u)
		}
	}
}
