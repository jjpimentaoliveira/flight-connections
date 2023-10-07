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

    /// Fetches flight connections asynchronously from the flight service.
    ///
    /// This method makes an asynchronous call to the `flightService` to retrieve flight connections.
    /// Upon success, it updates the `connections` property and sets the `fetchState` to `.fetched`.
    /// In case of an error, it sets the `fetchState` to `.error` and provides details about the error.
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
