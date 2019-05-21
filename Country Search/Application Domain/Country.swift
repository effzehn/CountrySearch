//
//  Country.swift
//  Country Search
//
//  Created by A. Hoffmann on 17.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import CoreLocation

struct Country {
    let code: String
    let name: String
    let area: Int
    let latLong: [Double]
    let population: Int
    let capital: String
    let region: String
    let regionalBlocks: [String]
    let languages: [String]
    let currencies: [String]
}

extension Country: DistanceCaluculatable {
    var location: CLLocation {
        guard let lat = latLong.first, let long = latLong.last else {
            return CLLocation()
        }

        return CLLocation(latitude: lat, longitude: long)
    }

    func distance(from otherLocation: CLLocation) -> Double {
        return location.distance(from: otherLocation)
    }
}

