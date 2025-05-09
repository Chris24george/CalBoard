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
                
                if let lastUpdate = viewModel.lastUpdateTime {
                    Text("Last updated: \(formatTime(lastUpdate))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Departures List
                List {
                    if viewModel.isLoading && viewModel.departures.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .listRowBackground(Color.clear)
                    } else if viewModel.northboundDepartures.isEmpty && viewModel.southboundDepartures.isEmpty {
                        Text("No upcoming departures")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .listRowBackground(Color.clear)
                    } else {
                        if !viewModel.northboundDepartures.isEmpty {
                            Section(header: Text("Northbound").font(.title2).padding(.vertical, 5)) {
                                ForEach(viewModel.northboundDepartures) { departure in
                                    DepartureRowView(departure: departure)
                                }
                            }
                        }

                        if !viewModel.southboundDepartures.isEmpty {
                            Section(header: Text("Southbound").font(.title2).padding(.vertical, 5)) {
                                ForEach(viewModel.southboundDepartures) { departure in
                                    DepartureRowView(departure: departure)
                                }
                            }
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
            .overlay(
                Group {
                    if viewModel.showToast {
                        VStack {
                            Spacer()
                            Toast(message: viewModel.toastMessage)
                        }
                    }
                }
            )
            .alert("Error", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
