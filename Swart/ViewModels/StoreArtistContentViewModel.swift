//
//  StoreArtistContentViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 14/11/2021.
//

import SwiftUI

final class StoreArtistContentViewModel: ObservableObject {
    
    @Published var numberOfPhotos: Int = 0
    @Published var numberOfVideos: Int = 0
    @Published var urlArrayForPhotos: [String] = []
    @Published var urlArrayForVideos: [String] = []
    @Published var hasUploadedProfilePhoto = false
    @Published var hasUploadedPresentationVideo = false
}
