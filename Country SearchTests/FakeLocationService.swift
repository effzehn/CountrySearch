//
//  FakeLocationService.swift
//  Country SearchTests
//
//  Created by A. Hoffmann on 22.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import CoreLocation
import Intents
import Contacts

class FakeLocationService: LocationServicable {
    var location: CLLocation?

    var placemark: CLPlacemark?

    func updateLocation() {}

    func locationAuthorization() {}

    private let locationManager = FakeLocationmanager()


    init() {
        createPlacemark()
    }

    private func createPlacemark() {
        location = CLLocation(latitude: 52.519143, longitude: 13.407476) // Berlin

        let address = CNMutablePostalAddress()
        address.city = "Berlin"
        address.isoCountryCode = "DE"
        address.country = "Germany"
        placemark = CLPlacemark(location: location!, name: "Test", postalAddress: address)
    }

    func removePlacemark() {
        placemark = nil
    }
}

class FakeLocationmanager: CLLocationManager {

    override class func locationServicesEnabled() -> Bool {
        return true
    }

    override class func authorizationStatus() -> CLAuthorizationStatus {
        return .authorizedWhenInUse
    }
}
