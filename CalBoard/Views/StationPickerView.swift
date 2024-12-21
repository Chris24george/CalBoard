//
//  StationPickerView.swift
//  CalBoard
//
//  Created by Chris George on 12/21/24.
//

// Views/StationPickerView.swift
import SwiftUI

struct StationPickerView: View {
    let selectedStation: Station
    let onSelect: (Station) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(Station.all) { station in
                Button(action: { onSelect(station) }) {
                    HStack {
                        Text(station.name)
                        Spacer()
                        if station.id == selectedStation.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Station")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
            )
        }
    }
}
