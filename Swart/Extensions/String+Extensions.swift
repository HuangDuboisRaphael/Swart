//
//  String+Extensions.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 23/03/2022.
//

import SwiftUI

// To extract only digits from a string.
extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
