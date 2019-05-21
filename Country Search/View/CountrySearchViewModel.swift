//
//  CountrySearchViewModel.swift
//  Country Search
//
//  Created by A. Hoffmann on 19.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import CoreLocation
import UIKit

struct CountrySearchViewModel {

    let title = "Country Search"

    var orderAscending = true

    var orderButtonTitle: String {
        return orderAscending ? "Closest" : "Farthest"
    }

    var isSearchActive = false

    var numberOfCountries: Int {
        if isSearchActive {
            return searchResults.count
        } else {
            return countryService.countries.count
        }
    }

    var currentCountry: Country? {
        return countryService.currentCountry
    }

    private var searchResults = [Country]()

    private let countryService: CountryService

    init(countryService: CountryService = CountryService(), imageService: ImageService = ImageService()) {
        self.countryService = countryService
    }

    func loadCountries(success: @escaping () -> Void) {
        countryService.fetch { successful in
            guard successful else {
                return
            }

            success()
        }
    }

    func country(for indexPath: IndexPath) -> Country? {
        let countries: [Country]?

        if isSearchActive {
            countries = searchResults
        } else {
            countries = countryService.countriesSortedByDistance(ascending: orderAscending)
        }

        guard indexPath.row < countries?.count ?? 0 else {
            return nil
        }

        return countries?[indexPath.row]
    }

    func flagImage(for indexPath: IndexPath, completion: @escaping (UIImage) -> Void) {
        guard let country = country(for: indexPath) else {
            return
        }

        countryService.flagImage(for: country.code) { image in
            completion(image)
        }
    }

    mutating func search(with term: String) {
        searchResults = countryService.searchCountries(for: term)
    }
}
