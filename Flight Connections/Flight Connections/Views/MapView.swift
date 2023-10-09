//
//  MapView.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 08/10/2023.
//

import MapKit
import SwiftUI

struct MapView: View {
    var cities: [City]
    var body: some View {
        Map() {
            ForEach(cities, id: \.self) { city in
                Marker(
                    city.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: city.coordinate.lat ?? 0.0,
                        longitude: city.coordinate.long ?? 0.0
                    )
                )
            }
        }
    }
}

#Preview {
    MapView(
        cities: [
            City(name: "Los Angeles", coordinate: Coordinate(lat: 34.052235, long: -118.243683)),
            City(name: "Tokyo", coordinate: Coordinate(lat: 35.652832, long: 139.839478)),
            City(name: "Sydney", coordinate: Coordinate(lat: -33.865143, long: 151.2099)),
            City(name: "Cape Town", coordinate: Coordinate(lat: -33.918861, long: 18.4233))
        ]
    )
}
