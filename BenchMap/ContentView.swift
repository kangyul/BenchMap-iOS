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
		ZStack {
			NaverMapView(userLocation: $locationVM.userLocation)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.ignoresSafeArea()

			// find bench button
			VStack {
				Spacer()
				Button {
//						benchVM.load(around: cameraCenter, radius: 1200)
				} label: {
					Label("이 위치에서 벤치 찾기", systemImage: "magnifyingglass")
						.font(.subheadline.weight(.semibold))
						.padding(.horizontal, 16).padding(.vertical, 12)
						.background(Color(red: 255/255, green: 178/255, blue: 92/255))
						.foregroundColor(.white)
						.cornerRadius(14)
				}
				.buttonStyle(.plain)
				.padding(.trailing, 16)
				.padding(.bottom, 32)
			}

		}
		// location auth button
		.overlay(alignment: .top) {
			if !locationVM.authorizationStatus.isAuthorized {
				Button {
					if [.denied, .restricted].contains(locationVM.authorizationStatus) {
						locationVM.openAppSettings()
					} else {
						locationVM.requestAuthorization()
					}
				} label: {
					HStack(spacing: 8) {
						Image(systemName: "location.fill")
						Text("현재 위치로 이동하려면 권한을 허용하세요")
							.font(.subheadline.weight(.semibold))
					}
					.padding(.horizontal, 14)
					.padding(.vertical, 10)
					.background(.ultraThinMaterial)
					.clipShape(Capsule())
					.shadow(radius: 3, y: 1)
				}
				.padding(.top, 12)
			}
		}
	}
}

#Preview {
	ContentView()
}
