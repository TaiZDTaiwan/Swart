//
//  UserRepositoryViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/09/2021.
//

import SwiftUI

final class UserCollectionViewModel: ObservableObject {
    
    @Published var user = User(firstName: "", lastName: "", birthdate: "", address: "", department: "", email: "", profilePhoto: "", wishlist: [], pendingRequest: [], comingRequest: [], previousRequest: [])
    
    static let collectionPath = "user"
    static let storagePathUserProfilePhoto = "users_profile_photos"
    
    private let userCollectionRepository = UserCollectionRepository()
    
    func addToUserCollection(documentId: String, user: User, completion: @escaping (() -> Void)) {
        userCollectionRepository.addToUserCollection(collectionPath: UserCollectionViewModel.collectionPath, documentId: documentId, user: user)
        completion()
    }
    
    func get(documentId: String, completion: (() -> Void)? = nil) {
        userCollectionRepository.get(collectionPath: UserCollectionViewModel.collectionPath, id: documentId) { user in
            self.user = user
            completion?()
        }
    }
    
    func addSingleDocumentToUserCollection(documentId: String, nameDocument: String, document: String) {
        userCollectionRepository.addSingleDocumentToUserCollection(collectionPath: UserCollectionViewModel.collectionPath, documentId: documentId, nameDocument: nameDocument, document: document)
    }

    func insertElementInArray(documentId: String, titleField: String, element: String, completion: (() -> Void)? = nil) {
        userCollectionRepository.insertElementInArray(collectionPath: UserCollectionViewModel.collectionPath, documentId: documentId, titleField: titleField, element: element)
        completion?()
    }
    
    func removeElementFromArray(documentId: String, titleField: String, element: String, completion: (() -> Void)? = nil) {
        userCollectionRepository.removeElementFromArray(collectionPath: UserCollectionViewModel.collectionPath, documentId: documentId, titleField: titleField, element: element)
        completion?()
    }
    
    func uploadProfilePhotoToDatabase(image: UIImage, documentId: String, nameField: String, completion: @escaping (Result<String, Error>) -> Void) {
        userCollectionRepository.uploadProfilePhotoToDatabase(storagePath: "users_profile_photos", collectionPath: UserCollectionViewModel.collectionPath, image: image, documentId: documentId, nameField: nameField, completion: completion)
    }
    
    func addAddressInformationToDatabase(documentId: String, documentAddress: String, documentDepartment: String, completion: @escaping (() -> Void)) {
        self.addSingleDocumentToUserCollection(documentId: documentId, nameDocument: "address", document: documentAddress)
        self.addSingleDocumentToUserCollection(documentId: documentId, nameDocument: "department", document: documentDepartment)
        completion()
    }
}
