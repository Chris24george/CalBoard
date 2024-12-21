//
//  StationDeparturesView.swift
//  CalBoard
//
//  Created by Chris George on 12/21/24.
//

import SwiftUI

struct StationDeparturesView: View {
    @StateObject private var viewModel: StationViewModel
    @State private var showingStationPicker = false
    
    init(station: Station = Station.all[0]) {
        _viewModel = StateObject(wrappedValue: StationViewModel(station: station))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Station Selection Button
                Button(action: { showingStationPicker = true }) {
                    HStack {
                        Text(viewModel.selectedStation.name)
                            .font(.headline)
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Departures List
                List {
                    if viewModel.isLoading && viewModel.departures.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .listRowBackground(Color.clear)
                    } else if viewModel.departures.isEmpty {
                        Text("No upcoming departures")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(viewModel.departures) { departure in
                            DepartureRowView(departure: departure)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    viewModel.fetchDepartures()
                }
            }
            .navigationTitle("Departures")
            .sheet(isPresented: $showingStationPicker) {
                StationPickerView(
                    selectedStation: viewModel.selectedStation,
                    onSelect: { station in
                        viewModel.setStation(station)
                        showingStationPicker = false
                    }
                )
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}
