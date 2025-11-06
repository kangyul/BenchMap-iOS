//
//  OSMNode.swift
//  BenchMap
//
//  Created by Yul Kang on 11/3/25.
//

import Foundation

struct OSMNode: Codable, Identifiable, Hashable {
	let id: Int
	let lat: Double
	let lon: Double
	let tags: [String: String]?

	var isBench: Bool {
		tags?["amenity"] == "bench"
	}

	var description: String {
		if let backrest = tags?["backrest"] {
			return backrest == "yes" ? "등받이 있음" :  "등받이 없음"
		}
		return "벤치"
	}

	enum OverpassQuery {
		static func benches(lat: Double, lon: Double, radiusMeters: Double) -> String {
			"""
			[out:json][timeout:25];
			(
				node["amenity"="bench"](around:\(Int(radiusMeters)),\(lat),\(lon));
			);
			out body;
			"""
		}
	}
}
