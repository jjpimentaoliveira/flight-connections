//
//  FlightServiceAPI.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import Foundation

class FlightServiceAPI: FlightServiceAPIProtocol {
    func fetchFlightConnections() async throws -> Connections {
        let endpoint = URL(string: "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json")

        guard let endpoint else { throw FlightServiceAPIError.invalidURL }

        let request = URLRequest(url: endpoint)

        do {
            print("Requesting flight connections...")

            let (data, response) = try await URLSession.shared.data(for: request)

            // Check if we can successfully convert the response from URLResponse? into HTTPURLResponse
            guard let httpResponse = response as? HTTPURLResponse else {
                throw FlightServiceAPIError.invalidResponse
            }

            // Check if request was successfully processed
            guard (200...299).contains(httpResponse.statusCode) else {
                throw FlightServiceAPIError.invalidStatusCode(httpResponse.statusCode)
            }

            // Check if data was returned
            guard !data.isEmpty else {
                throw FlightServiceAPIError.noDataReturned
            }

            let decodedResponse = try JSONDecoder().decode(Connections.self, from: data)
            return decodedResponse
        } catch let decodingError as DecodingError {
            throw FlightServiceAPIError.decodingError(decodingError)
        } catch {
            throw FlightServiceAPIError.networkError(error)
        }
    }
}
