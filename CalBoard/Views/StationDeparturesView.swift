import SwiftUI

struct StationDeparturesView: View {
    @StateObject private var viewModel: StationViewModel
    @State private var showingStationPicker = false
    @State private var animateRefresh = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var isNorthboundExpanded = true
    @State private var isSouthboundExpanded = true
    
    init(station: Station = Station.all[0]) {
        _viewModel = StateObject(wrappedValue: StationViewModel(station: station))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Station Header
                    stationHeaderView
                    
                    Divider()
                    
                    // Main Content
                    if viewModel.isLoading && viewModel.departures.isEmpty {
                        loadingView
                    } else if viewModel.northboundDepartures.isEmpty && viewModel.southboundDepartures.isEmpty {
                        emptyView
                    } else {
                        departuresListView
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Caltrain")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        refreshButton
                    }
                }
                
                // Toast overlay
                if viewModel.showToast {
                    toastView
                }
            }
            .sheet(isPresented: $showingStationPicker) {
                StationPickerView(
                    selectedStation: viewModel.selectedStation,
                    onSelect: { station in
                        viewModel.setStation(station)
                        showingStationPicker = false
                    }
                )
                .presentationDetents([.medium, .large])
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Button("Retry") { viewModel.fetchDepartures() }
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            }
        }
    }
    
    // MARK: - Subviews
    
    private var stationHeaderView: some View {
        Button(action: { showingStationPicker = true }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Image(systemName: "tram")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                        
                        Text(viewModel.selectedStation.name)
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    
                    if let lastUpdate = viewModel.lastUpdateTime {
                        Text("Updated \(formatTime(lastUpdate))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
    }
    
    private var refreshButton: some View {
        Button(action: {
            withAnimation {
                animateRefresh = true
                viewModel.fetchDepartures()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    animateRefresh = false
                }
            }
        }) {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .rotationEffect(.degrees(animateRefresh ? 360 : 0))
                .animation(animateRefresh ? .linear(duration: 1) : .default, value: animateRefresh)
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Text("Loading")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            Spacer()
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "train.side.front.car")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text("No upcoming departures")
                .font(.headline)
                .foregroundColor(.primary)
            
            Button(action: { viewModel.fetchDepartures() }) {
                Text("Refresh")
                    .font(.subheadline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Spacer()
        }
    }
    
    private var departuresListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Northbound Section
                if !viewModel.northboundDepartures.isEmpty {
                    collapsibleSection(
                        title: "Northbound",
                        symbol: "arrow.up",
                        count: viewModel.northboundDepartures.count,
                        isExpanded: $isNorthboundExpanded
                    ) {
                        ForEach(viewModel.northboundDepartures) { departure in
                            departureRow(departure: departure)
                                .padding(.bottom, 8)
                        }
                    }
                }
                
                // Southbound Section
                if !viewModel.southboundDepartures.isEmpty {
                    collapsibleSection(
                        title: "Southbound",
                        symbol: "arrow.down",
                        count: viewModel.southboundDepartures.count,
                        isExpanded: $isSouthboundExpanded
                    ) {
                        ForEach(viewModel.southboundDepartures) { departure in
                            departureRow(departure: departure)
                                .padding(.bottom, 8)
                        }
                    }
                }
                
                Text(viewModel.lastUpdateTime != nil ? "Last updated: \(formatTime(viewModel.lastUpdateTime!))" : "")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
            }
            .padding(.top, 16)
        }
        .refreshable {
            viewModel.fetchDepartures()
        }
    }
    
    // MARK: - Components
    
    private func collapsibleSection<Content: View>(
        title: String,
        symbol: String,
        count: Int,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header (tappable)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.wrappedValue.toggle()
                }
            }) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: symbol)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        
                        Text(title)
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Text("\(count)")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(4)
                        
                        Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 16)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            // Content (conditional)
            if isExpanded.wrappedValue {
                content()
            }
        }
    }
    
    private func departureRow(departure: DepartureInfo) -> some View {
        HStack(spacing: 16) {
            // Time
            VStack(alignment: .leading) {
                Text(formatTime(departure.scheduledTime))
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(.primary)
                
                if departure.isDelayed {
                    Text("+\(departure.delay) min")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.red)
                }
            }
            .frame(width: 65, alignment: .leading)
            
            // Route info
            VStack(alignment: .leading, spacing: 2) {
                Text("Route \(departure.routeId)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(timeUntilDeparture(departure.estimatedTime))
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Status indicator
            statusIndicator(for: departure)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : Color.white)
        )
        .padding(.horizontal, 16)
    }
    
    private func statusIndicator(for departure: DepartureInfo) -> some View {
        Group {
            if departure.isDelayed {
                Text("Delayed")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .cornerRadius(4)
            } else {
                Text("On Time")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .cornerRadius(4)
            }
        }
    }
    
    private var toastView: some View {
        VStack {
            Spacer()
            Toast(message: viewModel.toastMessage)
        }
    }
    
    // MARK: - Helper Functions
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func timeUntilDeparture(_ date: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute], from: now, to: date)
        
        if let minutes = components.minute {
            if minutes < 1 {
                return "Departing now"
            } else if minutes == 1 {
                return "Departing in 1 minute"
            } else {
                return "Departing in \(minutes) minutes"
            }
        }
        
        return "Departing soon"
    }
}

// MARK: - Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
