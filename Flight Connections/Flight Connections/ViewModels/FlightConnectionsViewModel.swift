//
//  FlightConnectionsViewModel.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import Foundation

enum FetchState {
    case loading
    case fetched(Connections)
    case error(Error)
}

class FlightConnectionsViewModel: ObservableObject {

    private let flightService: FlightServiceAPIProtocol

    @Published var fetchState: FetchState = .loading
    var connections: Connections?

    init(flightService: FlightServiceAPIProtocol = FlightServiceAPI()) {
        self.flightService = flightService
    }

    func fetchFlightConnections() async {
        do {
            connections = try await flightService.fetchFlightConnections()
            DispatchQueue.main.async { [weak self] in
                print("Connections successfully fetched")
                let connections = self?.connections ?? Connections(connections: [])
                self?.fetchState = .fetched(connections)
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                print("Error found while fetching connections")
                self?.fetchState = .error(error)
            }
        }
    }
}
