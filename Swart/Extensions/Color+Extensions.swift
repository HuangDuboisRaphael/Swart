//
//  Color+Extensions.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 08/09/2021.
//

import SwiftUI

// Swart colors extension used in the project.
extension Color {
    static let mainBeige = Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1))
    static let mainRed = Color(#colorLiteral(red: 0.7490196078, green: 0.1176470588, blue: 0.1843137255, alpha: 1))
    static let lightGrayForBackground = Color(#colorLiteral(red: 0.9486495852, green: 0.9492210746, blue: 0.969728291, alpha: 1))
    static let lightBlack = black.opacity(0.7)
    static let swartWhite = Color(red: 0.9529411765, green: 0.9490196078, blue: 0.9607843137)
    static let lightGray = Color(red: 0.756479919, green: 0.6241776347, blue: 0.6169845462)
    static let selectedOrange = Color(red: 1, green: 0.7142756581, blue: 0.59502846).opacity(0.3)
    static let checkGreen = Color(red: 2 / 255, green: 110 / 255, blue: 90 / 255)
    static let pendingOrange = Color(red: 255 / 255, green: 94 / 255, blue: 0 / 255)
}
