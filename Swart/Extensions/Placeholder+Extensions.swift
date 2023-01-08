//
//  Placeholder+Extensions.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 28/09/2021.
//

import SwiftUI

// Extension for custom placeholder to insert in textfield.
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
