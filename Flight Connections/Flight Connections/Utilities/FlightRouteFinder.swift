//
//  FlightRouteFinder.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 04/10/2023.
//

import Foundation

class FlightRouteFinder: FlightRouteFinderProtocol {
    
    /// A collection of cities and their flight connections used for route calculations.
    ///
    /// The `departureCities` dictionary maps city names to `City` objects, where each `City` contains  information about the city and its *outgoing* flight connections.
    var departureCities: [String: City] = [:]

    /// Adds connections to the `FlightRouteFinder` for further route calculations.
    ///
    /// - Parameter connections: An array of `Connection` objects representing flight connections.
    /// Only connections with valid 'from' and 'to' city names and non-negative prices will be added to the `FlightRouteFinder`.
    func addConnections(_ connections: [Connection]) {
        for connection in connections {
            if
                let from = connection.from, from.isEmpty == false,
                let to = connection.to, to.isEmpty == false,
                let price = connection.price, price >= 0
            {
                if departureCities[from] == nil {
                    departureCities[from] = City(name: from, connections: [connection])
                } else {
                    departureCities[from]?.connections.append(connection)
                }
            }
        }
    }

    /// Attempts to find the cheapest route between two cities using the `FlightRouteFinder`.
    ///
    /// - Parameters:
    ///   - departureCity: The city where the journey begins.
    ///   - destinationCity: The city where the journey ends.
    /// - Returns: A `Result` containing either the cheapest route (as an array of city names) and its cost or an error of type `RouteFinderError` if no valid path is found.
    func findCheapestRoute(departureCity: String, destinationCity: String) -> Result<(path: [String], cost: Int), RouteFinderError> {
        print("\nTrying to find the cheapest connection from \(departureCity) to \(destinationCity)\n")
        var cheapestRoute: [String] = []
        var minCost = Int.max

        func exploreConnections(currentRoute: [String], currentCost: Int, currentCity: String, visited: Set<String>) {
            print("Exploring connections from: \(currentCity)")

            guard currentCity != destinationCity else {
                if currentCost < minCost {
                    minCost = currentCost
                    cheapestRoute = currentRoute
                }
                print("Found valid destination! Route: \(currentRoute), Cost: \(currentCost)")
                return
            }

            guard let current = departureCities[currentCity] else {
                print("\(currentCity) has no departures. Moving on...")
                return
            }

            for connection in current.connections {
                if 
                    let newCity = connection.to,
                    visited.contains(newCity) == false,
                    currentRoute.contains(newCity) == false
                {
                    let newRoute = currentRoute + [newCity]
                    let newCost = currentCost + (connection.price ?? 0)
                    exploreConnections(
                        currentRoute: newRoute,
                        currentCost: newCost,
                        currentCity: newCity,
                        visited: visited.union([newCity])
                    )
                }
            }
        }

        exploreConnections(currentRoute: [departureCity], currentCost: 0, currentCity: departureCity, visited: Set())

        guard !cheapestRoute.isEmpty else {
            print("No valid route found")
            return .failure(.noValidRoute)
        }

        print("Cheapest route found: \(cheapestRoute), Cost: \(minCost)")
        return .success((cheapestRoute, minCost))
    }
}
