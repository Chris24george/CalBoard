//
//  DepartureInfo.swift
//  CalBoard
//
//  Created by Chris George on 12/21/24.
//

// Models/DepartureInfo.swift
import Foundation

struct DepartureInfo: Identifiable, Equatable {
    let id: String  // tripId
    let routeId: String
    let direction: String
    let scheduledTime: Date
    let estimatedTime: Date
    let delay: Int
    
    var isDelayed: Bool {
        delay > 0
    }
    
    static func == (lhs: DepartureInfo, rhs: DepartureInfo) -> Bool {
        lhs.id == rhs.id &&
        lhs.routeId == rhs.routeId &&
        lhs.direction == rhs.direction &&
        lhs.scheduledTime == rhs.scheduledTime &&
        lhs.estimatedTime == rhs.estimatedTime &&
        lhs.delay == rhs.delay
    }
}
