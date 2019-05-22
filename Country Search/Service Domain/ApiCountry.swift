//
//  ApiCountry.swift
//  Country Search
//
//  Created by A. Hoffmann on 17.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import Foundation

/*
 Service domain models for deserialization.
 */

struct ApiCountryList: Decodable {
    let countries: [ApiCountry]
}

struct ApiRegionalBloc: Decodable {
    let acronym: String
    let name: String
    let otherAcronyms: [String]
    let otherNames: [String]
}

struct ApiLanguage: Decodable {
    let iso639_1: String?
    let iso639_2: String?
    let name: String
    let nativeName: String
}

struct ApiCurrency: Decodable {
    let code: String?
    let name: String?
    let symbol: String?
}

struct ApiCountry: Decodable {
    let alpha2Code: String
    let latlng: [Double]
    let name: String
    let area: Double?
    let population: Int
    let capital: String
    let region: String
    let regionalBlocs: [ApiRegionalBloc]
    let languages: [ApiLanguage]
    let currencies: [ApiCurrency]?
}

extension ApiCountry {

    func convertToCountry() -> Country {
        let mappedRegionalBlocs = regionalBlocs.map {
            return $0.name
        }
        let mappedLanguages = languages.map {
            return $0.name
        }
        let mappedCurrencies = currencies?.map {
            var currencyDescription = ""

            if let name = $0.name {
                currencyDescription.append("\(name) ")
            }

            if let code = $0.code {
                currencyDescription.append("\(code) ")
            }

            if let symbol = $0.symbol {
                currencyDescription.append("\(symbol)")
            }

            return currencyDescription
        } ?? [String]()

        return Country(code: alpha2Code, name: name, area: Int(area ?? 0), latLong: latlng,
                       population: population, capital: capital, region: region,
                       regionalBlocks: mappedRegionalBlocs, languages: mappedLanguages,
                       currencies: mappedCurrencies)
    }
}
