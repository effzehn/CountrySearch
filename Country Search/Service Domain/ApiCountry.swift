//
//  ApiCountry.swift
//  Country Search
//
//  Created by A. Hoffmann on 17.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import Foundation

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
    let iso639_1: String
    let iso639_2: String
    let name: String
    let nativeName: String
}

struct ApiCurrency: Decodable {
    let code: String
    let name: String
    let symbol: String
}

struct ApiCountry: Decodable {
    let alpha2Code: String
    let name: String
    let area: Float
    let population: Int
    let capital: String
    let region: String
    let regionalBlocs: [ApiRegionalBloc]
    let languages: [ApiLanguage]
    let currencies: [ApiCurrency]
}
