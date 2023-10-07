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

    /// Finds the cheapest route between two cities.
    ///
    /// - Parameters:
    ///   - departureCity: The name of the departure city.
    ///   - destinationCity: The name of the destination city.
    ///
    /// - Returns: A `Result` containing the cheapest route and its cost if a valid route is found, or a `RouteFinderError` if the input is invalid or no route is found.
    func findCheapestRoute(
        departureCity: String,
        destinationCity: String
    ) -> Result<(route: [String], cost: Int), RouteFinderError>
}
