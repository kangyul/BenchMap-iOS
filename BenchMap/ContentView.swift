//
//  ContentView.swift
//  BenchMap
//
//  Created by Yul Kang on 10/29/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
	@StateObject private var locationVM = LocationViewModel()

	var body: some View {
		VStack(spacing: 16) {
			NaverMapView(userLocation: $locationVM.userLocation)
			.ignoresSafeArea()

			Button("위치 권한 요청") {
				locationVM.requestAuthorization()
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
	}
}

#Preview {
	ContentView()
}
