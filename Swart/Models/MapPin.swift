//
//  MapPin.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 30/10/2021.
//

import SwiftUI
import MapKit

struct MapPin: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
