//
//  Flight_ConnectionsTests.swift
//  Flight ConnectionsTests
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import XCTest
@testable import Flight_Connections

final class Flight_ConnectionsTests: XCTestCase {

    var mockFlightService: MockFlightServiceAPI = MockFlightServiceAPI()
    var flightViewModel: FlightConnectionsViewModel?
    var suggestionsViewModel: SuggestionsViewModel?
    var routeResultViewModel: RouteResultViewModel?
    var flightRouteFinder: FlightRouteFinder = FlightRouteFinder()

    override func setUp() {
        super.setUp()

        flightViewModel = FlightConnectionsViewModel(flightService: mockFlightService)
        suggestionsViewModel = SuggestionsViewModel(uniqueCities: loadConnectionsFromJSON().uniqueCities())
        routeResultViewModel = RouteResultViewModel()
    }

    override func tearDown() {
        flightViewModel = nil
        suggestionsViewModel = nil
        routeResultViewModel = nil
        super.tearDown()
    }

    func loadConnectionsFromJSON() -> Connections {
        let jsonData = """
         {
           "connections": [
             {
               "from": "London",
               "to": "Tokyo",
               "coordinates": {
                 "from": {
                   "lat": 51.5285582,
                   "long": -0.241681
                 },
                 "to": {
                   "lat": 35.652832,
                   "long": 139.839478
                 }
               },
               "price": 220
             },
             {
               "from": "Tokyo",
               "to": "London",
               "coordinates": {
                 "from": {
                   "lat": 35.652832,
                   "long": 139.839478
                 },
                 "to": {
                   "lat": 51.5285582,
                   "long": -0.241681
                 }
               },
               "price": 200
             },
             {
               "from": "London",
               "to": "Porto",
               "price": 50,
               "coordinates": {
                 "from": {
                   "lat": 51.5285582,
                   "long": -0.241681
                 },
                 "to": {
                   "lat": 41.14961,
                   "long": -8.61099
                 }
               }
             },
             {
               "from": "Tokyo",
               "to": "Sydney",
               "price": 100,
               "coordinates": {
                 "from": {
                   "lat": 35.652832,
                   "long": 139.839478
                 },
                 "to": {
                   "lat": -33.865143,
                   "long": 151.2099
                 }
               }
             },
             {
               "from": "Sydney",
               "to": "Cape Town",
               "price": 200,
               "coordinates": {
                 "from": {
                   "lat": -33.865143,
                   "long": 151.2099
                 },
                 "to": {
                   "lat": -33.918861,
                   "long": 18.4233
                 }
               }
             },
             {
               "from": "Cape Town",
               "to": "London",
               "price": 800,
               "coordinates": {
                 "from": {
                   "lat": -33.918861,
                   "long": 18.4233
                 },
                 "to": {
                   "lat": 51.5285582,
                   "long": -0.241681
                 }
               }
             },
             {
               "from": "London",
               "to": "New York",
               "price": 400,
               "coordinates": {
                 "from": {
                   "lat": 51.5285582,
                   "long": -0.241681
                 },
                 "to": {
                   "lat": 40.73061,
                   "long": -73.935242
                 }
               }
             },
             {
               "from": "New York",
               "to": "Los Angeles",
               "price": 120,
               "coordinates": {
                 "from": {
                   "lat": 40.73061,
                   "long": -73.935242
                 },
                 "to": {
                   "lat": 34.052235,
                   "long": -118.243683
                 }
               }
             },
             {
               "from": "Los Angeles",
               "to": "Tokyo",
               "price": 150,
               "coordinates": {
                 "from": {
                   "lat": 34.052235,
                   "long": -118.243683
                 },
                 "to": {
                   "lat": 35.652832,
                   "long": 139.839478
                 }
               }
             }
           ]
         }
        """
            .data(using: .utf8) ?? Data()

        do {
            return try JSONDecoder().decode(Connections.self, from: jsonData)
        } catch {
            XCTFail("Error decoding JSON: \(error)")
            return Connections(connections: [])
        }
    }

    func test_FetchFlightConnections_Successful() async {
        mockFlightService.fetchFlightConnectionsError = nil

        await flightViewModel?.fetchFlightConnections()

        XCTAssertTrue(mockFlightService.didCallFetchFlightConnections)
        XCTAssertEqual(flightViewModel?.connections?.connections.count, 2)
    }

    func test_FetchFlightConnections_Failure_InvalidResponse() async {
        mockFlightService.fetchFlightConnectionsError = .invalidResponse

        await flightViewModel?.fetchFlightConnections()

        XCTAssertTrue(mockFlightService.didCallFetchFlightConnections)
        XCTAssertEqual(flightViewModel?.connections?.connections.count, nil)
    }

    func test_FindCheapestConnection_SuccessfulRoute() {
        let connections = loadConnectionsFromJSON()
        flightRouteFinder.addConnections(connections)

        let result1 = flightRouteFinder.findCheapestRoute(departureCity: "Tokyo", destinationCity: "Sydney")
        let result2 = flightRouteFinder.findCheapestRoute(departureCity: "London", destinationCity: "Sydney")
        let result3 = flightRouteFinder.findCheapestRoute(departureCity: "  los angeles", destinationCity: "CAPE TOWN ")

        XCTAssertNotNil(result1)
        XCTAssertNotNil(result2)
        XCTAssertNotNil(result3)

        switch result1 {
        case .success(let (route, cost)):
            XCTAssertEqual(cost, 100)
            XCTAssertEqual(route, ["Tokyo", "Sydney"])

        case .failure(let error):
            XCTFail("Error finding cheapest route: \(error)")
        }

        switch result2 {
        case .success(let (route, cost)):
            XCTAssertEqual(cost, 320)
            XCTAssertEqual(route, ["London", "Tokyo", "Sydney"])

        case .failure(let error):
            XCTFail("Error finding cheapest route: \(error)")
        }

        switch result3 {
        case .success(let (route, cost)):
            XCTAssertEqual(cost, 450)
            XCTAssertEqual(route, ["Los Angeles", "Tokyo", "Sydney", "Cape Town"])

        case .failure(let error):
            XCTFail("Error finding cheapest route: \(error)")
        }
    }

    func test_FindCheapestConnection_Success_Duplicate() {
        let connections = loadConnectionsFromJSON()
        flightRouteFinder.addConnections(connections)

        let result = flightRouteFinder.findCheapestRoute(departureCity: "Tokyo", destinationCity: "Tokyo")
        XCTAssertNotNil(result)

        switch result {
        case .success(let (route, cost)):
            XCTAssertEqual(cost, 0)
            XCTAssertEqual(route, ["Tokyo"])

        case .failure(let error):
            XCTFail("Error finding cheapest route: \(error)")
        }
    }

    func test_FindCheapestConnection_Failure_NoConnectionFound() {
        let connections = loadConnectionsFromJSON()
        flightRouteFinder.addConnections(connections)

        let result = flightRouteFinder.findCheapestRoute(departureCity: "Guimarães", destinationCity: "Porto")
        XCTAssertNotNil(result)

        switch result {
        case .success:
            XCTFail("No route should have been found")

        case .failure(let error):
            XCTAssertEqual(error, .noRouteFound)
        }
    }

    func test_FindCheapestConnection_Failure_InvalidInput() {
        let connections = loadConnectionsFromJSON()
        flightRouteFinder.addConnections(connections)

        let result1 = flightRouteFinder.findCheapestRoute(departureCity: "Guimarães", destinationCity: "")
        XCTAssertNotNil(result1)

        switch result1 {
        case .success:
            XCTFail("No route should have been found")

        case .failure(let error):
            XCTAssertEqual(error, .invalidInput)
        }

        let result2 = flightRouteFinder.findCheapestRoute(departureCity: "", destinationCity: "Guimarães")
        XCTAssertNotNil(result2)

        switch result2 {
        case .success:
            XCTFail("No route should have been found")

        case .failure(let error):
            XCTAssertEqual(error, .invalidInput)
        }
    }

    func test_AddConnections_Success() {
        let connections = loadConnectionsFromJSON()
        flightRouteFinder.addConnections(connections)

        XCTAssertEqual(flightRouteFinder.departureCities.count, 6)
        XCTAssertEqual(flightRouteFinder.departureCities["Los Angeles"]?.connections.count, 1)
        XCTAssertEqual(flightRouteFinder.departureCities["London"]?.connections.count, 3)
        XCTAssertEqual(flightRouteFinder.departureCities["Porto"]?.connections.count, nil)
        XCTAssertEqual(flightRouteFinder.departureCities["Sydney"]?.connections.first?.to, "Cape Town")
        XCTAssertEqual(flightRouteFinder.departureCities["Sydney"]?.connections.first?.from, "Sydney")
        XCTAssertEqual(flightRouteFinder.departureCities["New York"]?.connections.first?.to, "Los Angeles")
        XCTAssertEqual(flightRouteFinder.departureCities["New York"]?.connections.first?.price, 120)
    }

    func test_AddConnection_Failure() {
        flightRouteFinder.departureCities.removeAll()
        flightRouteFinder.addConnections(Connections(
            connections: [
                Connection(
                    from: "",
                    to: "Destination",
                    coordinates: Coordinates(
                        from: Coordinate(lat: 10, long: 20),
                        to: Coordinate(lat: 10, long: 20)
                    ),
                    price: 100
                ),
                Connection(
                    from: "Source",
                    to: "    ",
                    coordinates: Coordinates(
                        from: Coordinate(lat: 10, long: 20),
                        to: Coordinate(lat: 10, long: 20)
                    ),
                    price: 100
                ),
                Connection(
                    from: "Source",
                    to: "Destination",
                    coordinates: Coordinates(
                        from: Coordinate(lat: 10, long: 20),
                        to: Coordinate(lat: 10, long: 20)
                    ),
                    price: -50
                )
            ]
        ))

        XCTAssertEqual(flightRouteFinder.departureCities.count, 0)
    }

    func testUpdateResultTextSuccess() {
        let successResult: Result<(route: [String], cost: Int), RouteFinderError> = .success((route: ["City A", "City B"], cost: 100))
        routeResultViewModel?.updateResultText(result: successResult)
        XCTAssertEqual(routeResultViewModel?.resultText, "City A -> City B\nTravel costs: 100")
    }

    func testUpdateResultTextFailure() {
        let failureResult1: Result<(route: [String], cost: Int), RouteFinderError> = .failure(.invalidInput)
        routeResultViewModel?.updateResultText(result: failureResult1)
        XCTAssertEqual(routeResultViewModel?.resultText, "No connection found: invalidInput")

        let failureResult2: Result<(route: [String], cost: Int), RouteFinderError> = .failure(.noRouteFound)
        routeResultViewModel?.updateResultText(result: failureResult2)
        XCTAssertEqual(routeResultViewModel?.resultText, "No connection found: noRouteFound")
    }

    func testUpdateResultTextSingleCity() {
        let singleCityResult: Result<(route: [String], cost: Int), RouteFinderError> = .success((route: ["City A"], cost: 0))
        routeResultViewModel?.updateResultText(result: singleCityResult)
        XCTAssertEqual(routeResultViewModel?.resultText, "You could just walk, you know? 🚶🏻‍♂️")
    }

    func test_Suggestions_Departure() {
        suggestionsViewModel?.updateSuggestions(for: .departure, with: "New")
        XCTAssertTrue(suggestionsViewModel?.departureSuggestions.contains(.city("New York")) ?? false)

        suggestionsViewModel?.updateSuggestions(for: .departure, with: "Porto")
        XCTAssertTrue(suggestionsViewModel?.departureSuggestions.contains(.noSuggestions) ?? false)
    }

    func test_Suggestions_Destination() {
        suggestionsViewModel?.updateSuggestions(for: .destination, with: "Lon")
        XCTAssertTrue(suggestionsViewModel?.destinationSuggestions.contains(.city("London")) ?? false)

        suggestionsViewModel?.updateSuggestions(for: .destination, with: "Guimarães")
        XCTAssertTrue(suggestionsViewModel?.destinationSuggestions.contains(.noSuggestions) ?? false)
    }
}
