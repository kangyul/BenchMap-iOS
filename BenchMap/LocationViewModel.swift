//
//  LocationViewModel.swift
//  BenchMap
//
//  Created by Yul Kang on 10/29/25.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var userLocation: CLLocationCoordinate2D?
	@Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

	private let manager = CLLocationManager()

	override init() {
		super.init()
		manager.delegate = self
	}

	func requestAuthorization() {
		// 사용자에게 위치 권한 요청
		manager.requestWhenInUseAuthorization()
	}

	// 권한 상태 바뀔 때마다 호출
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		authorizationStatus = manager.authorizationStatus

		switch authorizationStatus {
		case .authorizedWhenInUse, .authorizedAlways:
			manager.startUpdatingLocation()
		case .denied, .restricted:
			print("위치 권한 거부됨")
		default:
			break
		}
	}

	// 위치 업데이트 수신
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let loc = locations.last else { return }
		userLocation = loc.coordinate
		print("📍 현재 위치: \(loc.coordinate.latitude), \(loc.coordinate.longitude)")
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("❌ 위치 업데이트 실패:", error.localizedDescription)
	}
}
