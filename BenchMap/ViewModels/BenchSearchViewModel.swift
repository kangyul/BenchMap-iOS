//
//  BenchSearchViewModel.swift
//  BenchMap
//
//  Created by Yul Kang on 11/6/25.
//

import Foundation
import Combine

@MainActor
final class BenchSearchViewModel: ObservableObject {
	@Published var benches: [Bench] = []

	private let service = OverpassService()

	func search(lat: Double, lon: Double, radiusMeters: Double) {
		Task {
			benches = try await service
				.fetchBenches(lat: lat, lon: lon, radiusMeters: radiusMeters)
		}
	}
}
