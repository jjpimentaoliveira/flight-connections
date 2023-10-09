//
//  RouteResultView.swift
//  Flight Connections
//
//  Created by José Oliveira on 06/10/2023.
//

import SwiftUI

struct RouteResultView: View {
    @ObservedObject var routeResultViewModel: RouteResultViewModel
    var routeFinderResult: Result<RouteFinderResult, RouteFinderError>

    var body: some View {
        VStack {
            Text(routeResultViewModel.resultText)
                .font(.headline)
                .padding()
                .multilineTextAlignment(.center)

            switch routeFinderResult {
            case .success(let result):
                NavigationLink(destination: MapView(cities: result.route)) {
                    Text("Go to map")
                        .padding()
                }
            case .failure:
                Text("")
            }
        }
    }
}

#Preview {
    RouteResultView(
        routeResultViewModel: RouteResultViewModel(),
        routeFinderResult: .success(RouteFinderResult(
            route: [
                City(name: "London", coordinate: Coordinate(lat: 51.5285582, long: -0.241681)),
                City(name: "Tokyo", coordinate: Coordinate(lat: 35.652832, long: 139.839478)),
                City(name: "Sydney", coordinate: Coordinate(lat: -33.865143, long: 151.2099))
            ],
            cost: 100
        ))
    )
}
