//
//  UserRepositoryViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/09/2021.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI

final class UserRepositoryViewModel: ObservableObject {
    
    @Published var userSwart = UserSwart(id: "", firstName: "", lastName: "", birthdate: "", email: "")
    
    private let collectionPath = "user"
    private let store = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    func addUserToDatabase(id: String, user: UserSwart) {
    
        do {
            let _ = try store.collection("user").document(id).setData(from: user)
            print("Document successfully written!")
        }
        catch {
            print("Error writing document: \(error)")
        }
    }
    
    func get(documentPath: String) {
        let docRef = store.collection(collectionPath).document(documentPath)

        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: UserSwart.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    self.userSwart = user
                    print(self.userSwart.firstName)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func fetchDataToDb(id: String?, firstName: String, lastName: String) {
        store.collection("user").document(id ?? "").setData(["firstName": firstName, "lastName": lastName]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func uploadProfileImage(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1) {
            storage.child("\(String(describing: userSwart.id))_profile_photo").putData(imageData, metadata: nil) {
                (_, err) in
                if let err = err {
                    print("An error has occured - \(err.localizedDescription)")
                } else {
                    print("Image uploaded successfully")
                }
            }
        }
    }
}
