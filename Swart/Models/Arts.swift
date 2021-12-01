//
//  Arts.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 05/10/2021.
//

import SwiftUI

struct Art: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct ArtList {
    static let arts = [
    Art(name: "Cooking", imageName: "Cooking"),
    Art(name: "Craft", imageName: "Craft"),
    Art(name: "Fashion", imageName: "Fashion"),
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
