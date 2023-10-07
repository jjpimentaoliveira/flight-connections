//
//  RouteResultView.swift
//  Flight Connections
//
//  Created by José Oliveira on 06/10/2023.
//

import SwiftUI

struct RouteResultView: View {
    @ObservedObject var routeResultViewModel: RouteResultViewModel

    var body: some View {
        Text(routeResultViewModel.resultText)
            .font(.headline)
            .padding()
            .multilineTextAlignment(.center)
    }
}

#Preview {
    RouteResultView(routeResultViewModel: RouteResultViewModel())
}
