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
    private let apiKey: String = "REDACTED_511_API_KEY"  // Replace with your key
    
    func fetchTripUpdates() async throws -> Data {
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
