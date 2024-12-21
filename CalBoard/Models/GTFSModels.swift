// Models/GTFSModels.swift
import Foundation

struct GTFSResponse: Codable {
    let header: Header
    let entities: [Entity]
    
    enum CodingKeys: String, CodingKey {
        case header = "Header"
        case entities = "Entities"
    }
}

struct Header: Codable {
    let gtfsRealtimeVersion: String
    let incrementality: Int
    let timestamp: Int64
    
    enum CodingKeys: String, CodingKey {
        case gtfsRealtimeVersion = "GtfsRealtimeVersion"
        case incrementality = "incrementality"
        case timestamp = "Timestamp"
    }
}

struct Entity: Codable {
    let id: String
    let tripUpdate: TripUpdate?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case tripUpdate = "TripUpdate"
    }
}

struct TripUpdate: Codable {
    let trip: Trip
    let stopTimeUpdates: [StopTimeUpdate]
    let timestamp: Int64
    
    enum CodingKeys: String, CodingKey {
        case trip = "Trip"
        case stopTimeUpdates = "StopTimeUpdates"
        case timestamp = "Timestamp"
    }
}

struct Trip: Codable {
    let tripId: String
    let routeId: String
    let directionId: Int
    
    enum CodingKeys: String, CodingKey {
        case tripId = "TripId"
        case routeId = "RouteId"
        case directionId = "DirectionId"
    }
}

struct StopTimeUpdate: Codable {
    let stopId: String
    let arrival: StopTimeEvent?
    let departure: StopTimeEvent?
    
    enum CodingKeys: String, CodingKey {
        case stopId = "StopId"
        case arrival = "Arrival"
        case departure = "Departure"
    }
}

struct StopTimeEvent: Codable {
    let delay: Int?
    let time: Int64?
    
    enum CodingKeys: String, CodingKey {
        case delay = "Delay"
        case time = "Time"
    }
}
