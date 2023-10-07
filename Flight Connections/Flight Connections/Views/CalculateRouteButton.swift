//
//  CalculateRouteButton.swift
//  Flight Connections
//
//  Created by José Oliveira on 06/10/2023.
//

import SwiftUI

struct CalculateRouteButton: View {
    var action: () -> Void

    var body: some View {
        Button("Calculate Cheapest Route") {
            action()
        }
        .padding()
    }
}

#Preview {
    CalculateRouteButton(action: {
        print("Button pressed")
    })
}
