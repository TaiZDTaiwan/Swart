//
//  UserSwart.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/09/2021.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var firstName: String
    var lastName: String
    var birthdate: String
    var email: String
    
    static let profilePhotoFileName = "users_profile_photos"
}
