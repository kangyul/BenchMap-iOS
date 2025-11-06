//
//  Bench.swift
//  BenchMap
//
//  Created by Yul Kang on 11/6/25.
//

struct Bench {
	let id: Int64
	let latitude: Double
	let longitude: Double
	let tags: [String]

	enum OverpassQuery {
		static func benches(latitude: Double, longitude: Double, radiusMeters: Double) -> String {
			"""
			[out:json][timeout:25];
			(
				node["amenity"="bench"](around:\(Int(radiusMeters)),\(latitude),\(longitude));
			);
			out body;
			"""
		}
	}
}
