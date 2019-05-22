//
//  LocationService.swift
//  Country Search
//
//  Created by A. Hoffmann on 19.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import CoreLocation

let kDidUpdateLocationNotification = Notification.Name(rawValue: "didUpdateLocationNotification")
let kDidUpdatePlacemarkNotification = Notification.Name(rawValue: "didUpdatePlacemarkNotification")


/*
 Provides any needed location(manager)-based functionality to the application domain.
 */
class LocationService: NSObject {

    static let shared = LocationService()

    private var locationManager: CLLocationManager
    private var authorized: Bool = false

    var location: CLLocation? {
        didSet {
            NotificationCenter.default.post(name: kDidUpdateLocationNotification, object: nil)
        }
    }

    var placemark: CLPlacemark? {
        didSet {
            NotificationCenter.default.post(name: kDidUpdatePlacemarkNotification, object: nil)
        }
    }

    init?(locationManager: CLLocationManager = CLLocationManager()) {
        guard CLLocationManager.locationServicesEnabled() else {
            return nil
        }

        self.locationManager = locationManager
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        super.init()

        locationAuthorization()

        self.locationManager.delegate = self
        self.updateLocation()
    }

    func updateLocation() {
        guard authorized else { return }

        locationManager.requestLocation()
    }

    func locationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            authorized = true
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            fallthrough
        default:
            authorized = false
        }
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        if let location = location {
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                if let error = error {
                    debugPrint("Error finding placemark: \(error)")
                    return
                }

                if let placemark = placemark?.last {
                    self.placemark = placemark
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Error updating location: \(error)")
        // UI error handling
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            authorized = true
            updateLocation()
        } else {
            authorized = false
        }
    }
}
