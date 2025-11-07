//
//  OverpassService.swift
//  BenchMap
//
//  Created by Yul Kang on 11/6/25.
//

import Foundation

struct OverpassResponse: Decodable {
	let elements: [Bench]
}

final class OverpassService {
	func fetchBenches(lat: Double, lon: Double, radiusMeters: Double) async throws -> [Bench] {
		let query = Bench.OverpassQuery.benches(
			lat: lat,
			lon: lon,
			radiusMeters: radiusMeters)

		var request = URLRequest(url: URL(string: "https://overpass-api.de/api/interpreter")!)
		request.httpMethod = "POSt"
		request.httpBody = "data=\(query)".data(using: .utf8)
		request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")

		let (data, _) = try await URLSession.shared.data(for: request)

		let decoded = try JSONDecoder().decode(OverpassResponse.self, from: data)
		return decoded.elements.filter { $0.isBench }
	}
}
