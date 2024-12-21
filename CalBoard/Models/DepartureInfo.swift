//
//  DepartureInfo.swift
//  CalBoard
//
//  Created by Chris George on 12/21/24.
//

// Models/DepartureInfo.swift
import Foundation

struct DepartureInfo: Identifiable {
    let id: String  // tripId
    let routeId: String
    let direction: String
    let scheduledTime: Date
    let estimatedTime: Date
    let delay: Int
    
    var isDelayed: Bool {
        delay > 0
    }
}
