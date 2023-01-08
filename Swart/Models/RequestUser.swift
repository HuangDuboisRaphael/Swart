//
//  RequestUser.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/02/2022.
//

import SwiftUI

// Request reserved for users structure to download and upload in Firebase.
struct RequestUser: Codable, Hashable {
    var requestId: String
    var headline: String
    var city: String
    var department: String
    var address: String
    var date: String
    var location: String
    var guest: String
    var coverPhoto: String
    var accepted: Bool
}
