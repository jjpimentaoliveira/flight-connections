//
//  FlightServiceAPIProtocol.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import Foundation

protocol FlightServiceAPIProtocol {
    func fetchFlightConnections() async throws -> Connections
}
