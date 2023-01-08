//
//  ViewIsHidden+Extensions.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 05/09/2021.
//

import SwiftUI

// Extension to hide a view.
extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
