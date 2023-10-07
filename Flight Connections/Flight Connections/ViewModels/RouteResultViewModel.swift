//
//  RouteResultViewModel.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 06/10/2023.
//

import Foundation

class RouteResultViewModel: ObservableObject {
    @Published var resultText: String = ""

    /// Updates the result text based on the given route calculation result.
    ///
    /// This method takes a `Result` containing either a successful route calculation result or an error.
    /// If the result is successful, it formats and sets the `resultText` with the calculated route and cost.
    /// In case of an error, it sets the `resultText` to display the error message.
    ///
    /// - Parameter result: A `Result` containing either a successful route or an error.
    func updateResultText(result: Result<(route: [String], cost: Int), RouteFinderError>) {
        switch result {
        case .success(let connection):
            if connection.route.count == 1 {
                resultText = "You could just walk, you know? 🚶🏻‍♂️"
            } else {
                resultText = "\(connection.route.joined(separator: " -> "))\nTravel costs: \(connection.cost)"
            }

        case .failure(let error):
            resultText = "No connection found: \(error)"
        }
    }
}
