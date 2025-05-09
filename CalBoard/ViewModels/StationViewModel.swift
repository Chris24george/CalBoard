// ViewModels/StationViewModel.swift
import Foundation
import SwiftUI

@MainActor
class StationViewModel: ObservableObject {
    @Published var selectedStation: Station
    @Published var departures: [DepartureInfo] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var lastUpdateTime: Date?
    @Published var showToast = false
    @Published var toastMessage = ""
    
    private var lastFetchTime: Date?
    private let minTimeBetweenFetches: TimeInterval = 60.0
    private let apiClient = CaltrainAPIClient()
    
    
    init(station: Station = Station.all[0]) {
        self.selectedStation = station
        fetchDepartures()
    }
    
    func setStation(_ station: Station) {
        if selectedStation.id != station.id {
            selectedStation = station
            lastFetchTime = nil
            fetchDepartures()
        }
    }
    
    func fetchDepartures() {
        // Silently ignore rapid refreshes
        if let lastFetch = lastFetchTime,
           Date().timeIntervalSince(lastFetch) < minTimeBetweenFetches {
            showToast = true
            toastMessage = "Please wait a minute between refreshes"
            
            // Hide toast after 2 seconds
            Task {
                try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                showToast = false
            }
            return
        }
        
        isLoading = true
        lastFetchTime = Date()
        let oldDepartures = departures
        
        Task {
            do {
                let data = try await apiClient.fetchTripUpdates()
                let response = try JSONDecoder().decode(GTFSResponse.self, from: data)
                
                // Process the decoded response
                let currentTime = Date()
                let stationDepartures = processTrips(response, forStation: selectedStation.id, after: currentTime)
                
                // Check if departures changed
                if stationDepartures != oldDepartures {
                    self.lastUpdateTime = Date()
                } else {
                    showToast = true
                    toastMessage = "No new updates available"
                    // Hide toast after 2 seconds
                    Task {
                        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                        showToast = false
                    }
                }
                
                self.departures = stationDepartures
                self.isLoading = false
            } catch {
                print("Error processing response:", error)
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    private func processTrips(_ response: GTFSResponse, forStation stationId: String, after: Date) -> [DepartureInfo] {
        var departures: [DepartureInfo] = []
        
        for entity in response.entities {
            guard let tripUpdate = entity.tripUpdate else { continue }
            
            // Find all stop time updates for this station
            let stationUpdates = tripUpdate.stopTimeUpdates.filter {
                $0.stopId == stationId || (selectedStation.altId != nil && $0.stopId == selectedStation.altId)
            }
            
            for update in stationUpdates {
                guard let departure = update.departure,
                      let departureTime = departure.time else { continue }
                
                let timestamp = TimeInterval(departureTime)
                let scheduledTime = Date(timeIntervalSince1970: timestamp)
                
                // Skip if departure is in the past
                guard scheduledTime > after else { continue }
                
                let delay = departure.delay ?? 0
                let estimatedTime = scheduledTime.addingTimeInterval(TimeInterval(delay))
                
                let departureInfo = DepartureInfo(
                    id: tripUpdate.trip.tripId,
                    routeId: tripUpdate.trip.routeId,
                    direction: tripUpdate.trip.directionId == 0 ? "Northbound" : "Southbound",
                    scheduledTime: scheduledTime,
                    estimatedTime: estimatedTime,
                    delay: delay
                )
                
                departures.append(departureInfo)
            }
        }
        
        // Sort by departure time
        return departures.sorted { $0.scheduledTime < $1.scheduledTime }
    }
}
