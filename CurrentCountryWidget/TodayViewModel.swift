//
//  TodayViewModel.swift
//  CurrentCountryWidget
//
//  Created by A. Hoffmann on 21.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import UIKit

class TodayViewModel {

    var currentCountry: Country? {
        return countryService.currentCountry
    }

    private let countryService: CountryService
    private let locationService: LocationService?

    private var placemarkCompletion: (() -> Void)?

    init(countryService: CountryService = CountryService(), locationService: LocationService? = LocationService.shared) {
        self.countryService = countryService
        self.locationService = locationService
    }

    func fetchCountryList(completion: @escaping () -> Void) {
        countryService.fetch { _ in
            completion()
        }
    }

    func update(with completion: @escaping () -> Void) {
        placemarkCompletion = completion
        locationService?.updateLocation()
    }

    func reloadAfterUpdate() {
        placemarkCompletion?()
    }

    func flagImage(for countryCode: String, completion: @escaping (UIImage) -> Void) {
        countryService.flagImage(for: countryCode) { image in
            completion(image)
        }
    }
}
