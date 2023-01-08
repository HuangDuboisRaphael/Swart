//
//  Address.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 25/10/2021.
//

import SwiftUI

// Address to store in database or to use with geocoder.
struct Address: Codable {
    var country: String
    var locality: String
    var thoroughfare: String
    var postalCode: String
    var subThoroughfare: String
}
