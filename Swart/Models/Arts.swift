//
//  Arts.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 05/10/2021.
//

import SwiftUI

// To store the different arts names proposed and their related images.
struct Art: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct ArtList {
    static let arts = [
    Art(name: "Cooking", imageName: "Cooking"),
    Art(name: "Craft", imageName: "Craft"),
    Art(name: "Fashion Design", imageName: "Fashion Design"),
    Art(name: "Film", imageName: "Film"),
    Art(name: "Graphic Design", imageName: "Graphic Design"),
    Art(name: "Literature", imageName: "Literature"),
    Art(name: "Magic", imageName: "Magic"),
    Art(name: "Music", imageName: "Music"),
    Art(name: "Painting", imageName: "Painting"),
    Art(name: "Sculpture", imageName: "Sculpture"),
    Art(name: "Theater", imageName: "Theater")
    ]
}

struct ArtListLogo {
    static let artsLogo = [
    Art(name: "Cooking", imageName: "Cooking Logo"),
    Art(name: "Craft", imageName: "Craft Logo"),
    Art(name: "Fashion Design", imageName: "Fashion Design Logo"),
    Art(name: "Film", imageName: "Film Logo"),
    Art(name: "Graphic Design", imageName: "Graphic Design Logo"),
    Art(name: "Literature", imageName: "Literature Logo"),
    Art(name: "Magic", imageName: "Magic Logo"),
    Art(name: "Music", imageName: "Music Logo"),
    Art(name: "Painting", imageName: "Painting Logo"),
    Art(name: "Sculpture", imageName: "Sculpture Logo"),
    Art(name: "Theater", imageName: "Theater Logo")
    ]
}
