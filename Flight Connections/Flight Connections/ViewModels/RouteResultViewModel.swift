//
//  RouteResultViewModel.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 06/10/2023.
//

import Foundation

class RouteResultViewModel: ObservableObject {
    @Published var resultText: String = ""

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
