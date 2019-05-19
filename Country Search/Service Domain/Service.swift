//
//  Service.swift
//  Country Search
//
//  Created by A. Hoffmann on 17.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import Foundation

private let kRCBaseUrlPath = "https://restcountries.eu"

private let kRCApiPath = "rest/v2"

private enum RestCountryApiUrl: String {
    case name
    case capital
    case lang

    var url: URL {
        return URL(fileURLWithPath: kRCBaseUrlPath)
            .appendingPathComponent(kRCApiPath, isDirectory: true)
            .appendingPathComponent(self.rawValue, isDirectory: false)
    }
}

private func restCountryFilterQueryItem(fromMembersOf object: Decodable.Type) -> URLQueryItem? {
    let mirror = Mirror(reflecting: object)

    var value: String?
    for child in mirror.children {
        if let label = child.label {
            value?.append(label)
            value?.append(";")
        }
    }

    if value?.count ?? 0 > 0 {
        return URLQueryItem(name: "filter", value: value)
    } else {
        return nil
    }
}

private enum RestCountryRequest {
    case searchByName(name: String)
    case searchByCapital(capital: String)
    case searchByLanguage(language: String)

    var request: URLRequest? {
        let url: URL
        switch self {
        case .searchByName(let name):
            url = RestCountryApiUrl.name.url.appendingPathComponent(name, isDirectory: false)
        case .searchByCapital(let capital):
            url = RestCountryApiUrl.capital.url.appendingPathComponent(capital, isDirectory: false)
        case .searchByLanguage(let language):
            url = RestCountryApiUrl.lang.url.appendingPathComponent(language, isDirectory: false)
        }

        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = restCountryFilterQueryItem(fromMembersOf: ApiCountry.self) {
            components.queryItems?.append(queryItems)
            if let url = components.url {
                return URLRequest(url: url)
            }
        }

        return nil
    }
}

struct RestCountryService {

    /*
     Search as per requirement that calls on three differen API endpoints.
     */
    func search(with term: String, success: @escaping (ApiCountryList) -> Void, failure: @escaping (Error?) -> Void) {
        guard let nameRequest = RestCountryRequest.searchByName(name: term).request,
            let capitalRequest = RestCountryRequest.searchByCapital(capital: term).request,
            let languageRequest = RestCountryRequest.searchByLanguage(language: term).request else {
                failure(nil)
                return
        }

        let session = URLSession.shared

        let nameTask = session.dataTask(with: nameRequest) { (data, response, error) in
            guard let data = data else {
                failure(error)
                return
            }

            if let list = try? JSONDecoder().decode(ApiCountryList.self, from: data) {
                success(list)
            } else {
                failure(nil)
            }
        }

        let capitalTask = session.dataTask(with: capitalRequest) { (data, response, error) in
            guard let data = data else {
                failure(error)
                return
            }

            if let list = try? JSONDecoder().decode(ApiCountryList.self, from: data) {
                success(list)
            } else {
                failure(nil)
            }
        }

        let languageTask = session.dataTask(with: languageRequest) { (data, response, error) in
            guard let data = data else {
                failure(error)
                return
            }

            if let list = try? JSONDecoder().decode(ApiCountryList.self, from: data) {
                success(list)
            } else {
                failure(nil)
            }
        }

        nameTask.resume()
        capitalTask.resume()
        languageTask.resume()
    }
}
