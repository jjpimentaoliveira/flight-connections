//
//  SuggestionsViewModel.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 07/10/2023.
//

import Foundation

enum CitySuggestion: Equatable, Hashable {
    case city(String)
    case noSuggestions
}

class SuggestionsViewModel: ObservableObject {

    private var uniqueDepartures: [String] = []
    private var uniqueDestinations: [String] = []

    @Published var departureSuggestions: [CitySuggestion] = []
    @Published var destinationSuggestions: [CitySuggestion] = []

    init(uniqueCities: (departures: [String], destinations: [String])) {
        uniqueDepartures = uniqueCities.departures
        updateSuggestions(for: .departure)
        
        uniqueDestinations = uniqueCities.destinations
        updateSuggestions(for: .destination)
    }

    func updateSuggestions(for textFieldType: TextFieldConnectionType, with input: String = "") {
        switch textFieldType {
        case .departure:
            updateSuggestions(with: input, in: uniqueDepartures, to: &departureSuggestions)
        case .destination:
            updateSuggestions(with: input, in: uniqueDestinations, to: &destinationSuggestions)
        }
    }

    private func updateSuggestions(with input: String, in cities: [String], to suggestions: inout [CitySuggestion]) {
        let filteredCities = cities.filter { $0.hasPrefix(input) }
        suggestions = filteredCities.isEmpty ? [.noSuggestions] : filteredCities.map { .city($0) }
    }
}
