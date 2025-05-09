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
    @State private var searchText = ""
    @Environment(\.colorScheme) private var colorScheme
    
    var filteredStations: [Station] {
        if searchText.isEmpty {
            return Station.all
        } else {
            return Station.all.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar
                
                List {
                    ForEach(filteredStations) { station in
                        Button(action: { onSelect(station) }) {
                            HStack {
                                Text(station.name)
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if station.id == selectedStation.id {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Select Station")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(.subheadline, design: .rounded))
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search stations", text: $searchText)
                .font(.system(.body, design: .rounded))
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(10)
        .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}
