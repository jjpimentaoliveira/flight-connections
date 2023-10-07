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

    /// Updates the suggestions based on the provided input and list of cities.
    ///
    /// This private method filters a list of cities based on the input string.
    /// It populates the `suggestions` array with `CitySuggestion` objects that match the filtered cities.
    /// If there are no matching cities, it adds a `.noSuggestions` suggestion to indicate no matches.
    ///
    /// - Parameters:
    ///   - input: The input string used to filter cities.
    ///   - cities: The list of cities to filter.
    ///   - suggestions: The array to be populated with city suggestions.
    private func updateSuggestions(with input: String, in cities: [String], to suggestions: inout [CitySuggestion]) {
        let filteredCities = cities.filter { $0.hasPrefix(input) }
        suggestions = filteredCities.isEmpty ? [.noSuggestions] : filteredCities.map { .city($0) }
    }
}
