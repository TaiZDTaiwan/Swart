//
//  RequestArtist.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/02/2022.
//

import SwiftUI

struct RequestArtist: Codable, Hashable {
    var requestId: String
    var requestIdUser: String
    var idUser: String
    var firstName: String
    var city: String
    var department: String
    var address: String
    var date: String
    var location: String
    var guest: String
    var message: String
    var coverPhoto: String
    var accepted: Bool
}
