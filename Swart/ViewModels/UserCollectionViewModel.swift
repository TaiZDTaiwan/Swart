//
//  UserRepositoryViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/09/2021.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

final class UserCollectionViewModel: ObservableObject {
    
    @Published var userSwart = User(id: "", firstName: "", lastName: "", birthdate: "", email: "")
    
    static let collectionPath = "user"
    
    private let store = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    func addToUserCollection(id: String, user: User) {
        do {
            try store.collection(UserCollectionViewModel.collectionPath).document(id).setData(from: user)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func get(documentPath: String) {
        let docRef = store.collection(UserCollectionViewModel.collectionPath).document(documentPath)

        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    self.userSwart = user
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func uploadProfilePhoto(photo: UIImage, fileName: String, pathName: String) {
        if let imageData = photo.jpegData(compressionQuality: 1) {
            storage.child(fileName).child(pathName).putData(imageData, metadata: nil) { (_, err) in
                if let err = err {
                    print("An error has occured - \(err.localizedDescription)")
                } else {
                    print("Image uploaded successfully")
                }
            }
        }
    }
    
    func downloadProfilePhoto(progress: @escaping (Result<String, Error>) -> Void) {
        storage.child("users_profile_photos").child(userSwart.id ?? "").downloadURL { (url, error) in
            if error != nil {
                progress(.failure(error!))
            }
            if let url = url {
                progress(.success("\(url)"))
            }
        }
    }
}
