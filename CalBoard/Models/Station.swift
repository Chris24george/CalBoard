// Models/Station.swift
import Foundation

struct Station: Identifiable, Hashable {
    let id: String  // GTFS stop_id
    let altId: String?  // Alternative ID for some stations
    let name: String
    
    static let all: [Station] = [
        Station(id: "70011", altId: "70012", name: "San Francisco"),
        Station(id: "70021", altId: nil, name: "22nd Street"),
        Station(id: "70031", altId: nil, name: "Bayshore"),
        Station(id: "70041", altId: nil, name: "South San Francisco"),
        Station(id: "70051", altId: nil, name: "San Bruno"),
        Station(id: "70061", altId: nil, name: "Millbrae"),
        Station(id: "70071", altId: nil, name: "Broadway"),
        Station(id: "70081", altId: nil, name: "Burlingame"),
        Station(id: "70091", altId: nil, name: "San Mateo"),
        Station(id: "70101", altId: nil, name: "Hayward Park"),
        Station(id: "70111", altId: nil, name: "Hillsdale"),
        Station(id: "70121", altId: nil, name: "Belmont"),
        Station(id: "70131", altId: nil, name: "San Carlos"),
        Station(id: "70141", altId: nil, name: "Redwood City"),
        Station(id: "70151", altId: nil, name: "Menlo Park"),
        Station(id: "70161", altId: nil, name: "Palo Alto"),
        Station(id: "70171", altId: nil, name: "Stanford"),
        Station(id: "70181", altId: nil, name: "California Ave"),
        Station(id: "70191", altId: nil, name: "San Antonio"),
        Station(id: "70201", altId: nil, name: "Mountain View"),
        Station(id: "70211", altId: nil, name: "Sunnyvale"),
        Station(id: "70221", altId: nil, name: "Lawrence"),
        Station(id: "70231", altId: nil, name: "Santa Clara"),
        Station(id: "70241", altId: nil, name: "College Park"),
        Station(id: "70251", altId: nil, name: "San Jose Diridon"),
        Station(id: "70261", altId: nil, name: "Tamien"),
        Station(id: "70271", altId: nil, name: "Capitol"),
        Station(id: "70281", altId: nil, name: "Blossom Hill"),
        Station(id: "70291", altId: nil, name: "Morgan Hill"),
        Station(id: "70301", altId: nil, name: "San Martin"),
        Station(id: "70311", altId: nil, name: "Gilroy")
    ]
}
