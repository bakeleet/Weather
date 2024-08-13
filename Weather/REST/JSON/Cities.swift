//
//  Cities.swift
//  Weather
//
//  Created by bakeleet on 13/08/2024.
//

import Foundation

struct City: Codable {

    let name: String
    let localNames: [String: String]
    let lat, lon: Double
    let country, state: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

typealias Cities = [City]
