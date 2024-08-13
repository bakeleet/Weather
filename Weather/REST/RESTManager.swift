//
//  RESTManager.swift
//  Weather
//
//  Created by bakeleet on 13/08/2024.
//

import Foundation


class RESTManager {
    
    private enum RESTError: Error {
        case unparsableURL
        case pageNotFound
        case invalidServerResponse
    }

    static let shared = RESTManager()

    private var cache = RESTCache()

    func getCities(for name: String) async -> Cities? {
        let query = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        let url = "https://api.openweathermap.org/geo/1.0/direct?q=\(query)&appid=\(Environment.apiKey)"
        do {
            return try await getData(url, type: Cities.self)
        } catch RESTError.pageNotFound {
            print("[I] RESTManager - No data available for url: \(url)")
        } catch RESTError.unparsableURL {
            print("[E] RESTManager - Cannot process url: \(url)")
        } catch RESTError.invalidServerResponse {
            print("[E] RESTManager - Invalid server response for: \(url)")
        } catch {
            print("[E] RESTManager - Unexpected error: \(error).")
        }
        return nil
    }

    private func getData<T>(_ url: String, type: T.Type) async throws -> T where T: Decodable {
        if let response = cache.getRecentResponse(from: url) as? T {
            return response
        } else {
            return try await networkCall(url, type: type)
        }
    }

    private func networkCall<T>(_ url: String, type: T.Type) async throws -> T where T: Decodable {
        guard let resultUrl = URL(string: url) else {
            throw RESTError.unparsableURL
        }

        let (data, response) = try await URLSession.shared.data(from: resultUrl)
        if let response = response as? HTTPURLResponse, response.statusCode == 404 {
            throw RESTError.pageNotFound
        }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RESTError.invalidServerResponse
        }

        let decoder = JSONDecoder()
        let results = try decoder.decode(type, from: data)
        self.cache.add(results, from: url)
        print("[I] RESTManager - Caching data for url: \(url)")
        return results
    }
}
