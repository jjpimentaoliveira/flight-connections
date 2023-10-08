//
//  ConnectionSelectionView.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 04/10/2023.
//

import SwiftUI

enum TextFieldConnectionType {
    case departure
    case destination
}

struct ConnectionSelectionView: View {

    @Binding var selectedDepartureCity: String
    @Binding var selectedDestinationCity: String

    var buttonAction: () -> Void
    @ObservedObject var suggestionsViewModel: SuggestionsViewModel

    @FocusState private var departureTextFieldIsFocused: Bool
    @FocusState private var destinationTextFieldIsFocused: Bool

    var body: some View {
        VStack {
            Text("Select Departure City:")
                .font(.headline)

            TextField("Departure City", text: $selectedDepartureCity)
                .autocapitalization(.words)
                .textFieldStyle(.roundedBorder)
                .focused($departureTextFieldIsFocused)
                .onChange(of: departureTextFieldIsFocused) { _, newValue in
                    departureTextFieldIsFocused = newValue
                }

            if departureTextFieldIsFocused {
                SuggestionsView(
                    suggestions: suggestionsViewModel.departureSuggestions,
                    onSuggestionSelected: { selectedCity in
                        selectedDepartureCity = selectedCity
                    }
                )
            }

            Text("Select Destination City:")
                .font(.headline)

            TextField("Destination City", text: $selectedDestinationCity)
                .autocapitalization(.words)
                .textFieldStyle(.roundedBorder)
                .focused($destinationTextFieldIsFocused)
                .onChange(of: destinationTextFieldIsFocused) { _, newValue in
                    destinationTextFieldIsFocused = newValue
                }

            if destinationTextFieldIsFocused {
                SuggestionsView(
                    suggestions: suggestionsViewModel.destinationSuggestions,
                    onSuggestionSelected: { selectedCity in
                        selectedDestinationCity = selectedCity
                    }
                )
            }

            CalculateRouteButton {
                buttonAction()
            }

            Spacer()
        }
        .padding()
        .onChange(of: selectedDepartureCity) { _, newValue in
            suggestionsViewModel.updateSuggestions(for: .departure, with: newValue)
        }
        .onChange(of: selectedDestinationCity) { _, newValue in
            suggestionsViewModel.updateSuggestions(for: .destination, with: newValue)
        }
    }
}

#Preview {
    ConnectionSelectionView(
        selectedDepartureCity: .constant("Departure City"),
        selectedDestinationCity: .constant("Destination City"),
        buttonAction: { }, 
        suggestionsViewModel: SuggestionsViewModel(uniqueDeparturesAndDestinations: ([], []))
    )
}
