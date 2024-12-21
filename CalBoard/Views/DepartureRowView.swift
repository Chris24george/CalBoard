//
//  DepartureRowView.swift
//  CalBoard
//
//  Created by Chris George on 12/21/24.
//

// Views/DepartureRowView.swift
import SwiftUI

struct DepartureRowView: View {
    let departure: DepartureInfo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(departure.direction)
                    .font(.headline)
                Text("Route \(departure.routeId)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatTime(departure.scheduledTime))
                    .font(.headline)
                if departure.isDelayed {
                    Text("+\(departure.delay) min")
                        .font(.subheadline)
                        .foregroundColor(.red)
                } else {
                    Text("On Time")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
