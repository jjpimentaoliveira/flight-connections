//
//  SwapButton.swift
//  Flight Connections
//
//  Created by José João Pimenta Oliveira on 09/10/2023.
//

import SwiftUI

struct SwapButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: "arrow.up.arrow.down.circle")
        })
        .padding()
    }
}

#Preview {
    SwapButton(action: { })
}
