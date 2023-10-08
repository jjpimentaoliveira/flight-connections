//
//  Connections.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

struct Connections: Codable {
    let connections: [Connection]

    /// Calculates and returns unique departure and destination cities from the available flight connections.
    ///
    /// This function iterates through the flight connections and identifies unique departure and destination cities.
    ///
    /// - Returns: A tuple containing two arrays: `departures` and `destinations`, which represent unique departure and destination cities, respectively.
    func uniqueDeparturesAndDestinations() -> (departures: [String], destinations: [String]) {
        var uniqueDepartureSet = Set<String>()
        var uniqueDestinationSet = Set<String>()

        for connection in connections {
            if let departureCity = connection.from {
                uniqueDepartureSet.insert(departureCity)
            }
            if let destinationCity = connection.to {
                uniqueDestinationSet.insert(destinationCity)
            }
        }

        return (
            departures: Array(uniqueDepartureSet),
            destinations: Array(uniqueDestinationSet)
        )
    }
}
