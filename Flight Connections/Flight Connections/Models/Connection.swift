//
//  Connection.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 02/10/2023.
//

import Foundation

struct Connection: Codable {
    let from: String
    let to: String
    let coordinates: Coordinates?
    let price: Int
}
