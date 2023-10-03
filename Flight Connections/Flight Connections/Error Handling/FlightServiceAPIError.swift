//
//  FlightServiceAPIError.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import Foundation

enum FlightServiceAPIError: Error {
    case decodingError(Error)
    case invalidResponse
    case invalidStatusCode(Int)
    case invalidURL
    case networkError(Error)
    case noDataReturned
}
