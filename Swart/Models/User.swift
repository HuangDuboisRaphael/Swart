//
//  UserSwart.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/09/2021.
//

import SwiftUI

// User structure to download and upload in Firebase.
struct User: Codable, Hashable {
    var firstName: String
    var lastName: String
    var birthdate: String
    var address: String
    var department: String
    var email: String
    var profilePhoto: String
    var wishlist: [String]
    var pendingRequest: [String]
    var comingRequest: [String]
    var previousRequest: [String]
}
