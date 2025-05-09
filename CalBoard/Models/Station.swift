// Models/Station.swift
import Foundation

struct Station: Identifiable, Hashable {
    let id: String  // GTFS stop_id
    let altId: String?  // Alternative ID for some stations
    let name: String
    
    static let all: [Station] = [
        Station(id: "70011", altId: "70012", name: "San Francisco"),
        Station(id: "70021", altId: "70022", name: "22nd Street"),
        Station(id: "70031", altId: "70032", name: "Bayshore"),
        Station(id: "70041", altId: "70042", name: "South San Francisco"),
        Station(id: "70051", altId: "70052", name: "San Bruno"),
        Station(id: "70061", altId: "70062", name: "Millbrae"),
        Station(id: "70071", altId: "70072", name: "Broadway"),
        Station(id: "70081", altId: "70082", name: "Burlingame"),
        Station(id: "70091", altId: "70092", name: "San Mateo"),
        Station(id: "70101", altId: "70102", name: "Hayward Park"),
        Station(id: "70111", altId: "70112", name: "Hillsdale"),
        Station(id: "70121", altId: "70122", name: "Belmont"),
        Station(id: "70131", altId: "70132", name: "San Carlos"),
        Station(id: "70141", altId: "70142", name: "Redwood City"),
        Station(id: "70151", altId: "70152", name: "Menlo Park"),
        Station(id: "70161", altId: "70162", name: "Palo Alto"),
        Station(id: "70171", altId: "70172", name: "Stanford"),
        Station(id: "70181", altId: "70182", name: "California Ave"),
        Station(id: "70191", altId: "70192", name: "San Antonio"),
        Station(id: "70201", altId: "70202", name: "Mountain View"),
        Station(id: "70211", altId: "70212", name: "Sunnyvale"),
        Station(id: "70221", altId: "70222", name: "Lawrence"),
        Station(id: "70231", altId: "70232", name: "Santa Clara"),
        Station(id: "70241", altId: "70242", name: "College Park"),
        Station(id: "70261", altId: "70262", name: "San Jose Diridon"),
        Station(id: "70271", altId: "70272", name: "Tamien"),
        Station(id: "70281", altId: "70282", name: "Capitol"),
        Station(id: "70291", altId: "70292", name: "Blossom Hill"),
        Station(id: "70301", altId: "70302", name: "Morgan Hill"),
        Station(id: "70311", altId: "70312", name: "San Martin"),
        Station(id: "70321", altId: "70322", name: "Gilroy")
    ]
}
