//
//  FlightConnectionsView.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import SwiftUI

struct FlightConnectionsView: View {
    @StateObject private var viewModel = FlightConnectionsViewModel()
    @ObservedObject private var routeResultViewModel = RouteResultViewModel()
    @State private var routeFinderResult: Result<(route: [String], cost: Int), RouteFinderError> = .failure(.invalidInput)

    var body: some View {
        VStack {
            switch viewModel.fetchState {
            case .loading:
                ProgressView()

            case .fetched:
                RouteResultView(routeResultViewModel: routeResultViewModel)

            case .error(let error):
                Text("Error occurred: \(error.localizedDescription)")
                    .font(.headline)
                    .padding()
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
