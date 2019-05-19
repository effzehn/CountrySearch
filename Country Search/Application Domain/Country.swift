//
//  Country.swift
//  Country Search
//
//  Created by A. Hoffmann on 17.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import Foundation

struct CountryList {
    var countries: [Country]
}

struct Country {
    let code: String
    let name: String
    let area: Int
    let population: Int
    let capital: String
    let region: String
    let regionalBlocks: [String]
    let languages: [String]
    let currencies: [String]

    var flag
}

extension Country {

    static func create(with apiCountry: ApiCountry) -> Country {
        let regionalBlocs = apiCountry.regionalBlocs.map {
            return $0.name
        }
        let languages = apiCountry.languages.map {
            return $0.name
        }
        let currencies = apiCountry.currencies.map {
            return "\($0.name) (\($0.symbol))"
        }

        return Country(code: apiCountry.alpha3Code, name: apiCountry.name, area: Int(apiCountry.area),
                       population: apiCountry.population, capital: apiCountry.population, region: apiCountry.region,
                       regionalBlocks: regionalBlocs, languages: languages, currencies: currencies)
    }
}
