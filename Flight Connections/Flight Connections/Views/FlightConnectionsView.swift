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
    private let flightRouteFinder = FlightRouteFinder()

    @State private var selectedDepartureCity: String = ""
    @State private var selectedDestinationCity: String = ""
    @State private var routeFinderResult: Result<RouteFinderResult, RouteFinderError> = .failure(.invalidInput)

    var body: some View {
        NavigationView {
            VStack {
                switch flightConnectionViewModel.fetchState {
                case .loading:
                    ProgressView()

                case .fetched(let connections):
                    ScrollView {
                        ConnectionSelectionView(
                            selectedDepartureCity: $selectedDepartureCity,
                            selectedDestinationCity: $selectedDestinationCity,
                            calculateRouteButtonAction: {
                                flightRouteFinder.addConnections(connections)
                                routeFinderResult = flightRouteFinder.findCheapestRoute(
                                    departureCity: selectedDepartureCity,
                                    destinationCity: selectedDestinationCity
                                )
                                routeResultViewModel.updateResultText(result: routeFinderResult)
                            },
                            swapButtonAction: {
                                swap(&selectedDepartureCity, &selectedDestinationCity)
                            },
                            suggestionsViewModel: SuggestionsViewModel(
                                uniqueDeparturesAndDestinations: connections.uniqueDeparturesAndDestinations()
                            )
                        )

                        RouteResultView(
                            routeResultViewModel: routeResultViewModel,
                            routeFinderResult: routeFinderResult
                        )
                    }

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
        .navigationViewStyle(.stack)
    }
}

#Preview {
    FlightConnectionsView()
}
