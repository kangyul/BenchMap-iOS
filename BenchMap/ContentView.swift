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

			
			VStack {
				Spacer() // 버튼을 화면 아래쪽으로 내림
				Button(action: {
					locationVM.requestAuthorization()
				}) {
					Label("위치 권한 요청", systemImage: "location.fill")
						.font(.headline)
						.padding(.horizontal, 24)
						.padding(.vertical, 12)
						.background(Color(red: 255/255, green: 178/255, blue: 92/255))
						.foregroundColor(.white)
						.cornerRadius(12)
						.shadow(radius: 4)
				}
			}
		}
	}
}

#Preview {
	ContentView()
}
