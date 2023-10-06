//
//  RouteFinderError.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 06/10/2023.
//

/// Represents errors that can occur when finding routes between cities using the `FlightRouteFinder`.
enum RouteFinderError: Error {
    /// Indicates that no valid path was found between the specified cities.
    case noValidPath
}
