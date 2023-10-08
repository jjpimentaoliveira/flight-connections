//
//  FlightRouteFinder.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 04/10/2023.
//

import Foundation

class FlightRouteFinder {
    
    /// A collection of cities and their flight connections used for route calculations.
    ///
    /// The `departureCities` dictionary maps city names to `City` objects, where each `City` contains  information about the city and its *outgoing* flight connections.
    var departureCities: [String: [Connection]] = [:]
    var uniqueCities: Set<City> = []

    /// Adds flight connections to the `FlightRouteFinder` for further route calculations.
    ///
    /// - Parameters:
    ///   - connections: An instance of `Connections` containing flight connections.
    ///
    /// Only connections with valid 'from' and 'to' city names, and non-negative prices will be added to the `FlightRouteFinder`.
    func addConnections(_ connections: Connections) {
        for connection in connections.connections {
            guard
                let from = connection.from, from.trimmingCharacters(in: .whitespaces).isEmpty == false,
                let to = connection.to, to.trimmingCharacters(in: .whitespaces).isEmpty == false,
                let price = connection.price, price >= 0
            else {
                continue
            }

            addDepartureCityAndConnection(from, connection)
            if let fromCoordinates = connection.coordinates?.from {
                addCityCoordinate(from, fromCoordinates)
            }
            if let toCoordinates = connection.coordinates?.to {
                addCityCoordinate(to, toCoordinates)
            }
        }
    }

    private func addDepartureCityAndConnection(_ cityName: String, _ connection: Connection) {
        if departureCities[cityName] == nil {
            departureCities[cityName] = [connection]
        } else {
            departureCities[cityName]?.append(connection)
        }
    }

    private func addCityCoordinate(_ cityName: String, _ coordinates: Coordinate) {
        if let lat = coordinates.lat, let long = coordinates.long {
            let city = City(
                name: cityName,
                coordinate: Coordinate(
                    lat: lat,
                    long: long
                )
            )
            uniqueCities.insert(city)
        }
    }

    /// Finds the cheapest route between two cities using the flight route finder.
    ///
    /// - Parameters:
    ///   - departureCity: The name of the departure city.
    ///   - destinationCity: The name of the destination city.
    ///
    /// - Returns: A `Result` containing the cheapest route and its cost if a valid route is found, or a `RouteFinderError` if the input is invalid or no route is found.
    func findCheapestRoute(departureCity: String, destinationCity: String) -> Result<(route: [City], cost: Int), RouteFinderError> {
        let departureCity = departureCity.capitalized.trimmingCharacters(in: .whitespaces)
        let destinationCity = destinationCity.capitalized.trimmingCharacters(in: .whitespaces)

        guard
            departureCity.isEmpty == false,
            destinationCity.isEmpty == false
        else {
            return .failure(.invalidInput)
        }

        print("\nTrying to find the cheapest connection from \(departureCity) to \(destinationCity)\n")
        var citiesInCheapestRoute: [City] = []
        var minCost = Int.max

        func exploreConnections(currentRoute: [String], currentCost: Int, currentCity: String, visited: Set<String>) {
            print("Exploring connections from: \(currentCity)")

            guard currentCity != destinationCity else {
                if currentCost < minCost {
                    minCost = currentCost
                    citiesInCheapestRoute = currentRoute.compactMap { cityName in
                        uniqueCities.first { $0.name == cityName }
                    }
                }
                print("Found valid destination! Route: \(currentRoute), Cost: \(currentCost)")
                return
            }

            guard let connections = departureCities[currentCity] else {
                print("\(currentCity) has no departures. Moving on...")
                return
            }

            for connection in connections {
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

        guard !citiesInCheapestRoute.isEmpty else {
            print("No valid route found")
            return .failure(.noRouteFound)
        }

        print("Cheapest route found: \(citiesInCheapestRoute.map { $0.name }), Cost: \(minCost)")
        return .success((citiesInCheapestRoute, minCost))
    }
}
