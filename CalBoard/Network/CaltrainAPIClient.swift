// Network/CaltrainAPIClient.swift
import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError(Int)
    case decodingError(String)
}

class CaltrainAPIClient {
    private let apiKey: String = {
        // Prefer Secrets.plist (not committed)
        if let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
           let key = plist["API_KEY"] as? String, !key.isEmpty {
            return key
        }
        // Fallback to environment variable (useful for CI or local scheme)
        if let env = ProcessInfo.processInfo.environment["CALBOARD_API_KEY"], !env.isEmpty {
            return env
        }
        // Fallback to Info.plist key (avoid committing real keys)
        if let info = Bundle.main.object(forInfoDictionaryKey: "CALBOARD_API_KEY") as? String, !info.isEmpty {
            return info
        }
        return ""
    }()
    
    func fetchTripUpdates() async throws -> Data {
        // Require a non-empty API key before making the request
        guard !apiKey.isEmpty else {
            throw APIError.unauthorized
        }
        guard let url = URL(string: "https://api.511.org/transit/tripupdates") else {
            throw APIError.invalidURL
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "agency", value: "CT"),
            URLQueryItem(name: "api_key", value: apiKey),
            // Request JSON format instead of protobuf
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let finalURL = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // Print the response for debugging
        let responseString = String(decoding: data, as: UTF8.self)
        print("API Response Status Code:", httpResponse.statusCode)
        print("API Response Headers:", httpResponse.allHeaderFields)
        print("API Response Body:", responseString)
        
        switch httpResponse.statusCode {
        case 200:
            return data
        case 401:
            throw APIError.unauthorized
        default:
            throw APIError.serverError(httpResponse.statusCode)
        }
    }
}
