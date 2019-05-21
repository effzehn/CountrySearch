//
//  DistanceCaluculatable.swift
//  Country Search
//
//  Created by A. Hoffmann on 19.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import CoreLocation

protocol DistanceCaluculatable {
    var location: CLLocation { get }

    func distance(from location: CLLocation) -> Double
}
