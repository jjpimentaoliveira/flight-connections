//
//  RouteFinderError.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 06/10/2023.
//

/// Represents errors that can occur when finding routes between cities using the `FlightRouteFinder`.
enum RouteFinderError: Error {

    /// Indicates that the input provided for route finding is invalid.
    case invalidInput

    /// Indicates that no valid route was found between the specified cities.
    case noRouteFound
}
