//
//  RouteResultView.swift
//  Flight Connections
//
//  Created by José Oliveira on 06/10/2023.
//

import SwiftUI

struct RouteResultView: View {
    let result: Result<(path: [String], cost: Int), RouteFinderError>

    var body: some View {
        Text(resultText)
            .font(.headline)
            .padding()
            .multilineTextAlignment(.center)
    }

    private var resultText: String {
        switch result {
        case .success(let connection):
            if connection.path.count == 1 {
                if connection.path.first?.isEmpty ?? true {
                    return ""
                }
                return "You could just walk, you know? 🚶🏻‍♂️"
            }
            return "\(connection.path.joined(separator: " -> "))\nTravel costs: \(connection.cost)"

        case .failure(let error):
            return "No connection found: \(error)"
        }
    }
}

#Preview {
    RouteResultView(result: .success((path: ["Tokyo", "London", "Porto", "Cape Town"], cost: 100)))
}
