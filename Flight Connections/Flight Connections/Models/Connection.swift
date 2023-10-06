//
//  Connection.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

struct Connection: Codable {
    let from: String?
    let to: String?
    let coordinates: Coordinates?
    let price: Int?

    init(
        from: String?,
        to: String?,
        coordinates: Coordinates?,
        price: Int?
    ) {
        self.from = from?.capitalized
        self.to = to?.capitalized
        self.coordinates = coordinates
        self.price = price
    }
}
