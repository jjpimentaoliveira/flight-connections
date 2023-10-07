//
//  FlightConnectionsView.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import SwiftUI

struct FlightConnectionsView: View {
    @StateObject private var flightConnectionViewModel = FlightConnectionsViewModel()
    @ObservedObject private var routeResultViewModel = RouteResultViewModel()

    @State private var selectedDepartureCity: String = ""
    @State private var selectedDestinationCity: String = ""
    @State private var routeFinderResult: Result<(route: [String], cost: Int), RouteFinderError> = .failure(.invalidInput)

    var body: some View {
        VStack {
            switch flightConnectionViewModel.fetchState {
            case .loading:
                ProgressView()

            case .fetched:
                ConnectionSelectionView(
                    selectedDepartureCity: $selectedDepartureCity,
                    selectedDestinationCity: $selectedDestinationCity,
                    buttonAction: {
                        routeFinderResult = flightConnectionViewModel.findCheapestRoute(
                            departureCity: selectedDepartureCity.capitalized.trimmingCharacters(in: .whitespacesAndNewlines),
                            destinationCity: selectedDestinationCity.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
                        )

                        routeResultViewModel.updateResultText(result: routeFinderResult)
                    }
                )

                RouteResultView(routeResultViewModel: routeResultViewModel)

            case .error(let error):
                Text("Error occurred: \(error.localizedDescription)")
                    .font(.headline)
                    .padding()
            }
        }
        .task {
            await flightConnectionViewModel.fetchFlightConnections()
        }
        .padding()
    }
}

#Preview {
    FlightConnectionsView()
}
