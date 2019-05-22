//
//  ApiService.swift
//  Country Search
//
//  Created by A. Hoffmann on 17.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import UIKit

private let kRCBaseUrlPath = "https://restcountries.eu"

private let kRCApiPath = "rest/v2"


private enum RestCountryApiUrl: String {
    case all

    var url: URL {
        return URL(fileURLWithPath: kRCBaseUrlPath)
            .appendingPathComponent(kRCApiPath, isDirectory: true)
            .appendingPathComponent(self.rawValue, isDirectory: false)
    }
}


private enum RestCountryRequest {
    case listAll

    var request: URLRequest? {
        let url: URL
        switch self {
        case .listAll:
            url = RestCountryApiUrl.all.url
        }

        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let apiCountryScheme = ApiCountry.init(alpha2Code: "",
                                                   latlng: [0.0],
                                                   name: "",
                                                   area: nil,
                                                   population: 0,
                                                   capital: "",
                                                   region: "",
                                                   regionalBlocs: [],
                                                   languages: [],
                                                   currencies: nil)

            if let queryItems = restCountryFilterQueryItem(fromMembersOf: apiCountryScheme) {
                components.queryItems = [queryItems]
            }

            if let url = components.url {
                return URLRequest(url: url)
            }
        }

        return nil
    }

    func restCountryFilterQueryItem(fromMembersOf object: Decodable) -> URLQueryItem? {
        let mirror = Mirror(reflecting: object)

        var value = ""
        for (name, _) in mirror.children {
            if let label = name {
                value.append(label)
                value.append(";")
            }
        }

        if value.count > 0 {
            return URLQueryItem(name: "fields", value: value)
        } else {
            return nil
        }
    }
}


/*
 Provides an interface to the Rest Country API. Todo: Look for better name, remove protocol suffix
 */

protocol RestCountryServiceProtocol {
    func listAll(success: @escaping ([ApiCountry]) -> Void, failure: @escaping (Error?) -> Void)
}

struct RestCountryService: RestCountryServiceProtocol {

    /*
     Search as per requirement that calls on three differen API endpoints.
     */
    func listAll(success: @escaping ([ApiCountry]) -> Void, failure: @escaping (Error?) -> Void) {
        guard let listRequest = RestCountryRequest.listAll.request else {
            failure(nil)
            return
        }

        let session = URLSession.shared

        session.dataTask(with: listRequest) { (data, response, error) in
            if let error = error {
                failure(error)
                return
            }

            guard let data = data else {
                failure(error)
                return
            }

            do {
                let list = try JSONDecoder().decode([ApiCountry].self, from: data)
                success(list)
            } catch let decodingError {
                debugPrint("Error: \(decodingError)")
                failure(decodingError)
            }
        }.resume()
    }
}

/*
 Provides an interface to for downloading flags (and possibly other images)
 */
struct ImageService {

    private let kFlagBaseUrlPath = "https://www.countryflags.io/"

    func fetchFlagImage(for code: String, completion: @escaping (UIImage) -> Void) {
        if let baseUrl = URL(string: kFlagBaseUrlPath) {
            if let url = URL(string: "\(code.lowercased())/flat/64.png", relativeTo: baseUrl) {
                fetchImage(from: url, completion: completion)
            }
        }
    }

    func fetchImage(from url: URL, completion: @escaping (UIImage) -> Void) {

        let session = URLSession.shared

        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                debugPrint("Error fetching image: \(error)")
                return
            }

            guard let data = data else {
                debugPrint("No image data available!")
                return
            }

            if let image = UIImage(data: data) {
                completion(image)
            } else {
                debugPrint("Error creating image from data.")
            }
        }.resume()
    }
}
