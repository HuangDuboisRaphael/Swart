//
//  Artist.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 04/11/2021.
//

import SwiftUI

// Artist structure to download and upload in Firebase.
struct Artist: Codable, Hashable {
    var id: String
    var art: String
    var place: String
    var address: String
    var department: String
    var headline: String
    var textPresentation: String
    var profilePhoto: String
    var presentationVideo: String
    var artContentMedia: [String]
    var blockedDates: [String]
    var pendingRequest: [String]
    var comingRequest: [String]
    var previousRequest: [String]
}
