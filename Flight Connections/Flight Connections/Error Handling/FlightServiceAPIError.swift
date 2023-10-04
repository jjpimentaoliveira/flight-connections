//
//  FlightServiceAPIError.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import Foundation

/// Enum representing possible errors that can occur in the FlightServiceAPI.
enum FlightServiceAPIError: Error {

    /// An error that occurred during JSON decoding.
    /// - Parameter decodingError: The underlying error that caused the decoding failure.
    case decodingError(decodingError: Error)

    /// An error indicating that the response from the server is invalid.
    case invalidResponse

    /// An error indicating that the HTTP status code of the response is invalid.
    /// - Parameter statusCode: The HTTP status code received from the server.
    case invalidStatusCode(statusCode: Int)

    /// An error indicating that the provided URL is invalid.
    case invalidURL

    /// An error indicating a network-related issue.
    /// - Parameter networkError: The underlying error that occurred during the network operation.
    case networkError(networkError: Error)

    /// An error indicating that no data was returned from the server.
    case noDataReturned
}
