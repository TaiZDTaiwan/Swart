//
//  WishlistRepository.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 18/02/2022.
//

import Firebase

class WishlistRepository {
    
    private let store = Firestore.firestore()
    
    func getArtistsInWishlist(collectionPath: String, documentId: String, completion: @escaping (Artist) -> Void) {
        let docRef = store.collection(collectionPath).document(documentId)

        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: Artist.self)
            }
            switch result {
            case .success(let artist):
                if let artist = artist {
                    completion(artist)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
}
