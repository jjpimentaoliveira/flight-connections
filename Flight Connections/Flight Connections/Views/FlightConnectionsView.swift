//
//  FlightConnectionsView.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import SwiftUI

struct FlightConnectionsView: View {
    @StateObject private var viewModel = FlightConnectionsViewModel()

    var body: some View {
        VStack {
            switch viewModel.fetchState {
            case .loading:
                ProgressView()

            case .fetched(let connections):
                Text(connections.connections.first?.from ?? "")

            case .error(let error):
                Text("Error occurred: \(error.localizedDescription)")
            }
        }
        .task {
            await viewModel.fetchFlightConnections()
        }
        .padding()
    }
}

#Preview {
    FlightConnectionsView()
}
