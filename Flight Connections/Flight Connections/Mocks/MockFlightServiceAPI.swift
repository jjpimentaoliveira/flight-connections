//
//  MockFlightServiceAPI.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 03/10/2023.
//

import Foundation

/// A mock implementation of the `FlightServiceAPIProtocol` for testing purposes.
class MockFlightServiceAPI: FlightServiceAPIProtocol {

    var didCallFetchFlightConnections = false
    var fetchFlightConnectionsError: FlightServiceAPIError?

    /// Simulates the behaviour of asynchronously fetching flight connections for testing.
    ///
    /// - Returns: A predefined `Connections` object representing flight connections.
    /// - Throws: An error of type `FlightServiceAPIError` if any simulated issues occur during testing.
    ///
    /// - Note: This mock method is intended for testing and does not perform actual network requests.
    func fetchFlightConnections() async throws -> Connections {

        didCallFetchFlightConnections = true

        if let fetchFlightConnectionsError {
            throw fetchFlightConnectionsError
        }

        return Connections(connections: [
            Connection(
                from: "Guimarães",
                to: "Philadelphia",
                coordinates: Coordinates(
                    from: Coordinate(lat: 41.44443, long: -8.29619),
                    to: Coordinate(lat: 39.952414, long: -75.146301)
                ),
                price: 200
            ),
            Connection(
                from: "Philadelphia",
                to: "Guimarães",
                coordinates: Coordinates(
                    from: Coordinate(lat: 39.952414, long: -75.146301),
                    to: Coordinate(lat: 41.44443, long: -8.29619)
                ),
                price: 230
            )
        ])
    }
}
