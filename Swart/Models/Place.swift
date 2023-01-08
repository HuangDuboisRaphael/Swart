//
//  Place.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 09/01/2022.
//

import SwiftUI

// To store the different places names proposed and their related images.
struct Place: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct PlaceList {
    static let places = [
    Place(name: "Your place", imageName: "House Logo"),
    Place(name: "Artist's place", imageName: "House Artist Logo"),
    Place(name: "Anywhere suits you", imageName: "Any House Logo")
    ]
}

struct PlaceListArtistForm {
    static let places = [
    Place(name: "Your place", imageName: "House Logo"),
    Place(name: "Audience's place", imageName: "House Artist Logo"),
    Place(name: "Anywhere suits you", imageName: "Any House Logo")
    ]
}
