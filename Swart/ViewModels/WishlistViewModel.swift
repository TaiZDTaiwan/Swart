//
//  WishlistViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 31/01/2022.
//

import SwiftUI

final class WishlistViewModel: ObservableObject {
    
    @Published var artist = Artist(id: "", art: "", place: "", address: "", department: "", headline: "", textPresentation: "", profilePhoto: "", presentationVideo: "", artContentMedia: [], blockedDates: [], pendingRequest: [], comingRequest: [], previousRequest: [])
    @Published var wishedArtistsResult: [Artist] = []
    
    private let wishlistRepository = WishlistRepository()
    
    func getArtistsInWishlist(documentId: String, completion: (() -> Void)? = nil) {
        wishlistRepository.getArtistsInWishlist(collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId) { artist in
            self.artist = artist
            self.wishedArtistsResult.append(artist)
            completion?()
        }
    }
}
