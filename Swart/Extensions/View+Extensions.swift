//
//  View+Extensions.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 24/02/2022.
//

import SwiftUI

// Extension for background gradient to insert in views.
extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}
