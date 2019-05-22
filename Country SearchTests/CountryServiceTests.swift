//
//  Country_SearchTests.swift
//  Country SearchTests
//
//  Created by A. Hoffmann on 17.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import XCTest
@testable import Country_Search

class CountryServiceTests: XCTestCase {

    var countryService: CountryService!

    override func setUp() {
        countryService = CountryService(restCountryService: FakeRestCountryService(), locationService: FakeLocationService(), imageService: ImageService())
    }

    override func tearDown() {}

    func testFetch() {
        var calledCompletion = false

        countryService.fetch { success in
            calledCompletion = true
        }
        XCTAssertTrue(calledCompletion, "A fetch should call the completion closure.")
    }

    func testPerformanceForFetch() {
        // this will only test deserialization
        measure {
            countryService.fetch { _ in }
        }
    }

    func testCountryForCode() {
        countryService.fetch { _ in }
        XCTAssertEqual(countryService.country(for: "DE")?.code, "DE", "countryForCode should return correct Country.")
    }

    func testSearchCountries() {
        countryService.fetch { _ in }
        let result = countryService.searchCountries(for: "eng")

        XCTAssertTrue(result.count == 92, "There should be 92 results for \"eng\".")
    }

    func testPerformanceForSearchCountries() {
        countryService.fetch { _ in}
        measure {
            _ = countryService.searchCountries(for: "eng")
        }
    }

    func testCountriesSortedByDistance() {
        countryService.fetch { _ in }
        let country = countryService.countriesSortedByDistance(ascending: true)!.first
        XCTAssertEqual(country?.code, "CZ", "First country should be Czech Republic (CZ).")
    }
}

