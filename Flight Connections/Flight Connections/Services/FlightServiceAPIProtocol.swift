//
//  FlightServiceAPIProtocol.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import Foundation

/// A protocol for fetching flight connections from a remote JSON endpoint.
protocol FlightServiceAPIProtocol {
    
    /// Asynchronously fetches flight connections from a remote JSON endpoint.
    ///
    /// - Returns: A `Connections` object representing the fetched flight connections.
    /// - Throws: An error of type `FlightServiceAPIError` if any issues occur during the request and response processing.
    ///
    /// - Note: This method assumes that `Connections` is a Codable model representing flight connections.
    ///
    /// - Important: This method is asynchronous and should be called within an asynchronous context.
    func fetchFlightConnections() async throws -> Connections
}
