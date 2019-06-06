//
//  CountryService.swift
//  Country Search
//
//  Created by A. Hoffmann on 19.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import UIKit

final class CountryService {

    private let restCountryService: RestCountryServiceable
    private let locationService: LocationServicable?
    private let imageService: ImageServiceable

    private(set) var countries = [Country]()
    private var sortedCountries: [Country]?

    private var flagImageCache = Dictionary<String, UIImage>()

    init(restCountryService: RestCountryServiceable = RestCountryService(),
         locationService: LocationServicable? = LocationService.shared,
         imageService: ImageServiceable = ImageService()) {
        self.restCountryService = restCountryService
        self.locationService = locationService
        self.imageService = imageService
    }

    var currentCountry: Country? {
        guard let placemark = locationService?.placemark, let code = placemark.isoCountryCode else {
            return nil
        }

        return country(for: code)
    }

    /*
     Sorts the countries according to their center and the user's distance from it.
     This might not be coherent with the common understanding of distance because
     it does not incorporate the borders of the country, only the center. E.g. a user
     could be determined to be close to Belgium although he is located in Germany, but the center
     of Germany is further than the center of Belgium.
     */
    private func sortCountries() {
        guard let userLocation = locationService?.location else {
            return
        }

        sortedCountries = countries.sorted(by: { (countryA, countryB) -> Bool in
            return countryA.distance(from: userLocation) < countryB.distance(from: userLocation)
        })
    }

    func fetch(completion: @escaping (Bool) -> Void) {
        restCountryService.listAll(success: { apiCountries in
            self.countries = apiCountries.map({ apiCountry in
                return apiCountry.convertToCountry()
            })

            completion(true)
        }, failure: { (error) in
            debugPrint("Error fetching!")
            completion(false)
        })
    }

    func country(for code: String) -> Country? {
        return countries.filter({ country -> Bool in
            return country.code == code
        }).first
    }

    func searchCountries(for term: String) -> [Country] {
        let loTerm = term.lowercased()
        return countries.filter({ country -> Bool in
            return country.name.lowercased().contains(loTerm) ||
                    country.capital.lowercased().contains(loTerm) ||
                    country.languages.filter({ language -> Bool in
                        return language.lowercased().contains(loTerm)
                    }).count > 0
        })
    }

    func countriesSortedByDistance(ascending: Bool) -> [Country]? {
        guard locationService?.location != nil else {
            return countries
        }

        if sortedCountries == nil {
            sortCountries()
        }

        if ascending {
            return sortedCountries
        } else {
            return sortedCountries?.reversed()
        }
    }

    func flagImage(for code: String, completion: @escaping (UIImage) -> Void) {
        if let image = flagImageCache[code] {
            completion(image)
            return
        }

        imageService.fetchFlagImage(for: code) { image in
            self.flagImageCache[code] = image
            completion(image)
        }
    }
}
