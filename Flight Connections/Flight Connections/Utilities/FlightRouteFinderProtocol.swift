//
//  FlightRouteFinderProtocol.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 06/10/2023.
//

import Foundation

/// A protocol for finding the cheapest flight route between two cities.
protocol FlightRouteFinderProtocol {
    /// Adds flight connections to the route finder's data.
    ///
    /// - Parameter connections: An array of `Connection` objects representing flight connections.
    func addConnections(_ connections: [Connection])

    /// Finds the cheapest flight route between the specified departure and destination cities.
    ///
    /// - Parameters:
    ///   - departureCity: The name of the departure city.
    ///   - destinationCity: The name of the destination city.
    /// - Returns: A `Result` containing either the cheapest flight route and cost or an error.
    func findCheapestRoute(departureCity: String, destinationCity: String) -> Result<(path: [String], cost: Int), RouteFinderError>
}
