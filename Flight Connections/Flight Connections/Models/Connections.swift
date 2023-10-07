//
//  Connections.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

struct Connections: Codable {
    let connections: [Connection]

    func uniqueCities() -> (departures: [String], destinations: [String]) {
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
