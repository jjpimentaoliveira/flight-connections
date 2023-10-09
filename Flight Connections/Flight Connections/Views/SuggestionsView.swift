//
//  SuggestionsView.swift
//  Flight Connections
//
//  Created by José Oliveira on 06/10/2023.
//

import SwiftUI

struct SuggestionsView: View {
    var suggestions: [CitySuggestion]
    var onSuggestionSelected: (String) -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ForEach(suggestions, id: \.self) { suggestion in
                switch suggestion {
                case .city(let city):
                    Text(city)
                        .padding(8)
                        .foregroundStyle(Color.blue)
                        .onTapGesture {
                            onSuggestionSelected(city)
                            hideKeyboard()
                        }

                case .noSuggestions:
                    Text("No suggestions")
                        .padding(8)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding()
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SuggestionsView(
        suggestions: [.city("Porto"), .city("London")],
        onSuggestionSelected: { selectedCity in
            print("Selected city: \(selectedCity)")
        }
    )
}
