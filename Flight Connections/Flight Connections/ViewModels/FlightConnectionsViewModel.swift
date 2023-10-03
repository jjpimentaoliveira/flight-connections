//
//  FlightConnectionsViewModel.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import Foundation

enum FetchState {
    case loading
    case fetched(connections: Connections)
    case error(error: Error)
}

class FlightConnectionsViewModel: ObservableObject {

    @Published var fetchState: FetchState = .loading

    private let flightService: FlightServiceAPIProtocol
    private var connections: Connections?

    init(flightService: FlightServiceAPIProtocol = FlightServiceAPI()) {
        self.flightService = flightService
    }

    func fetchFlightConnections() async {
        do {
            connections = try await flightService.fetchFlightConnections()
            DispatchQueue.main.async { [weak self] in
                print("Connections successfully fetched")
                self?.fetchState = .fetched(connections: self?.connections ?? Connections(connections: []))
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                print("Error found while fetching connections")
                self?.fetchState = .error(error: error)
            }
        }
    }
}
