## CalBoard

An iOS SwiftUI app that displays a live Caltrain departures board for a selected station. It fetches GTFS‑Realtime trip updates from 511.org and presents upcoming trains split into Northbound and Southbound with delay status and “minutes until departure.”

### Highlights
- **Live data**: Uses 511.org GTFS‑Realtime Trip Updates for Caltrain.
- **Station search**: Quick picker with filtering to change stations.
- **Clear status**: On‑time vs delayed with readable time and ETA.
- **Collapsible sections**: Separate Northbound/Southbound lists.
- **Pull‑to‑refresh + toolbar refresh**: With a friendly 60s rate‑limit toast.
- **Resilient UX**: Error alert with Retry; “no new updates” toast.

### How it works
1. **MVVM + SwiftUI**: `StationViewModel` drives `StationDeparturesView`.
2. **Network**: `CaltrainAPIClient` calls the 511 Trip Updates endpoint for Caltrain (`agency=CT`, JSON format) and returns raw `Data`.
3. **Decoding**: `GTFSModels` (Codable) parse `TripUpdate` and `StopTimeUpdate` entries.
4. **Transform**: The view model filters stop updates for the selected station’s `stop_id` and optional `altId`, builds `DepartureInfo` with scheduled time, delay, estimated time, and direction, and splits results into Northbound/Southbound.
5. **Render**: `StationDeparturesView` shows collapsible sections, a refresh control, and a timestamp for the last successful update.

### Tech stack
- **UI**: SwiftUI
- **Architecture**: MVVM
- **Networking**: URLSession
- **Models**: Codable (GTFS‑Realtime JSON)

### Project structure
- `CalBoard/CalBoardApp.swift`: App entry point.
- `CalBoard/Models/`
  - `Station.swift`: Caltrain stations (with primary and optional alternate stop IDs).
  - `GTFSModels.swift`: Codable structures for 511 GTFS‑Realtime JSON.
  - `DepartureInfo.swift`: View‑friendly departure model.
- `CalBoard/Network/CaltrainAPIClient.swift`: 511 Trip Updates client.
- `CalBoard/ViewModels/StationViewModel.swift`: Fetching, transform, state, and rate‑limit logic.
- `CalBoard/Views/`
  - `StationDeparturesView.swift`: Main screen with collapsible sections.
  - `StationPickerView.swift`: Searchable station selector (sheet).
  - `DepartureRowView.swift`: Reusable row (auxiliary).
  - `Toast.swift`: Lightweight toast overlay.

### Notes
- Logs full HTTP response (headers/body) to the console for debugging; disable for production.
- Results merge updates for a station’s `id` and `altId` where applicable.
- “Last updated” only changes when the underlying departures list changes.

### Roadmap ideas
- Home screen widgets and Live Activities.
- Offline caching and smarter diffing.
- User favorites / default station persistence.
- Accessibility polish (Dynamic Type, VoiceOver hints).

### Data source
Powered by 511.org’s GTFS‑Realtime Trip Updates for Caltrain. See the official docs: [511.org GTFS‑Realtime](https://511.org/open-data/transit).


