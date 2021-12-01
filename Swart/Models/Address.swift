//
//  Address.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 25/10/2021.
//

import SwiftUI

struct Address: Codable {
    var country: String
    var locality: String
    // Ville
    var thoroughfare: String
    // Rue
    var postalCode: String
    var subThoroughfare: String
    // Num rue
}
