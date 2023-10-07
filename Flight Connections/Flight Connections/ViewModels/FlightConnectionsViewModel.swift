//
//  FlightConnectionsViewModel.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import Foundation

enum FetchState {
    case loading
    case fetched
    case error(error: Error)
}

class FlightConnectionsViewModel: ObservableObject {

    private let flightService: FlightServiceAPIProtocol
    private let flightRouteFinder: FlightRouteFinderProtocol

    @Published var fetchState: FetchState = .loading
    var connections: Connections?

    init(
        flightService: FlightServiceAPIProtocol = FlightServiceAPI(),
        flightRouteFinder: FlightRouteFinderProtocol = FlightRouteFinder()
    ) {
        self.flightService = flightService
        self.flightRouteFinder = flightRouteFinder
    }

    func fetchFlightConnections() async {
        do {
            connections = try await flightService.fetchFlightConnections()
            DispatchQueue.main.async { [weak self] in
                print("Connections successfully fetched")
                self?.flightRouteFinder.addConnections(self?.connections?.connections ?? [])
                self?.fetchState = .fetched
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                print("Error found while fetching connections")
                self?.fetchState = .error(error: error)
            }
        }
    }

    func findCheapestRoute(
        departureCity: String,
        destinationCity: String
    ) -> Result<(route: [String], cost: Int), RouteFinderError> {
        return flightRouteFinder.findCheapestRoute(
            departureCity: departureCity,
            destinationCity: destinationCity
        )
    }
}
