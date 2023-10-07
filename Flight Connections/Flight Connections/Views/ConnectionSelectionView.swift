//
//  ConnectionSelectionView.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 04/10/2023.
//

import SwiftUI

struct ConnectionSelectionView: View {

    @Binding var selectedDepartureCity: String
    @Binding var selectedDestinationCity: String

    var buttonAction: () -> Void

    var body: some View {
        VStack {
            Text("Select Departure City:")
                .font(.headline)

            TextField("Departure City", text: $selectedDepartureCity)
            .autocapitalization(.words)
            .textFieldStyle(.roundedBorder)

            Text("Select Destination City:")
                .font(.headline)

            TextField("Destination City", text: $selectedDestinationCity)
            .autocapitalization(.words)
            .textFieldStyle(.roundedBorder)

            CalculateRouteButton {
                buttonAction()
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ConnectionSelectionView(
        selectedDepartureCity: .constant("Departure City"),
        selectedDestinationCity: .constant("Destination City"),
        buttonAction: { }
    )
}
