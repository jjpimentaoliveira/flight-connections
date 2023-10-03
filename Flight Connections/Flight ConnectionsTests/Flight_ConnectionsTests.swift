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

    override func setUp() {
        super.setUp()
        flightViewModel = FlightConnectionsViewModel(flightService: mockFlightService)
    }

    override func tearDown() {
        flightViewModel = nil
        super.tearDown()
    }

    func test_FetchFlightConnections_Successful() async {
        mockFlightService.fetchFlightConnectionsError = nil

        await flightViewModel?.fetchFlightConnections()

        XCTAssertTrue(mockFlightService.didCallFetchFlightConnections)
        XCTAssertEqual(flightViewModel?.connections?.connections.count, 2)
    }

    func test_FetchFlightConnections_Failure() async {
        mockFlightService.fetchFlightConnectionsError = .invalidResponse

        await flightViewModel?.fetchFlightConnections()

        XCTAssertTrue(mockFlightService.didCallFetchFlightConnections)
        XCTAssertEqual(flightViewModel?.connections?.connections.count, nil)
    }
}
