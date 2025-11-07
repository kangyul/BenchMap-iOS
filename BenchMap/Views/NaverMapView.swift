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
	@Binding var cameraCenter: CLLocationCoordinate2D
	var searchRadiusMeters: Double
	var benches: [Bench]

	func makeCoordinator() -> Coordinator { Coordinator(cameraCenter: $cameraCenter) }

	func makeUIView(context: Context) -> NMFNaverMapView {
		let naver = NMFNaverMapView(frame: .zero)

		naver.showCompass = true
		naver.showLocationButton = true
		naver.showZoomControls = false
		naver.showScaleBar = true

		let mapView = naver.mapView
		mapView.positionMode = .normal

		mapView.addCameraDelegate(delegate: context.coordinator)

		let start = userLocation ?? CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
		let initUpdate = NMFCameraUpdate(
			scrollTo: NMGLatLng(lat: start.latitude, lng: start.longitude),
			zoomTo: 14
		)
		mapView.moveCamera(initUpdate)

		let circle = NMFCircleOverlay()
		circle.mapView = mapView
		circle.fillColor = UIColor.systemBlue.withAlphaComponent(0.12)
		circle.outlineColor = UIColor.systemBlue.withAlphaComponent(0.35)
		circle.outlineWidth = 1
		context.coordinator.circle = circle

		return naver
	}

	func updateUIView(_ naver: NMFNaverMapView, context: Context) {
		let mapView = naver.mapView

		// 최초 1회: 사용자 위치로 센터링
		if !context.coordinator.didCenterOnce, let c = userLocation {
			let u = NMFCameraUpdate(
				scrollTo: NMGLatLng(lat: c.latitude, lng: c.longitude),
				zoomTo: max(mapView.cameraPosition.zoom, 14)
			)
			u.animation = .easeIn
			mapView.moveCamera(u)
			context.coordinator.didCenterOnce = true
		}

		if let circle = context.coordinator.circle {
			circle.center = NMGLatLng(lat: cameraCenter.latitude, lng: cameraCenter.longitude)
			 circle.radius = searchRadiusMeters
			print("circle.radius: \(circle.radius)")
		}

		context.coordinator.syncMarkers(on: mapView, with: benches)
	}

	final class Coordinator: NSObject, NMFMapViewCameraDelegate {
		var didCenterOnce = false
		var circle: NMFCircleOverlay?
		var markers: [Int: NMFMarker] = [:]

		func syncMarkers(on mapView: NMFMapView, with benches: [Bench]) {
			let newIDs = Set(benches.map { $0.id })

			// remove
			for (id, m) in markers where !newIDs.contains(id) {
				m.mapView = nil
				markers.removeValue(forKey: id)
			}

			// add/update
			for b in benches {
				let marker = markers[b.id] ?? NMFMarker()
				marker.position = NMGLatLng(lat: b.lat, lng: b.lon)
				marker.captionText = b.description
				marker.mapView = mapView
				markers[b.id] = marker
			}
		}

		private var cameraCenter: Binding<CLLocationCoordinate2D>
		init(cameraCenter: Binding<CLLocationCoordinate2D>) {
			self.cameraCenter = cameraCenter
		}

		func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
			let target = mapView.cameraPosition.target
			cameraCenter.wrappedValue = CLLocationCoordinate2D(latitude: target.lat, longitude: target.lng)
			circle?.center = NMGLatLng(lat: target.lat, lng: target.lng)

			let zoom = mapView.cameraPosition.zoom
			print("zoom: \(zoom)")
		}
	}
}
