//
//  Artist.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 04/11/2021.
//

import SwiftUI

struct Artist: Codable {
    var art: String
    var place: String
    var address: String
    var headline: String
    var textPresentation: String
    
    static let profilePhotoFileName = "artists_profile_photos"
    static let videoPresentationFileName = "artists_presentation_videos"
    static let artContentFileName = "artists_content"
}
