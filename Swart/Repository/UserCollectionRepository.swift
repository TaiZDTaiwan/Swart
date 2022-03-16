//
//  UserCollection.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 16/02/2022.
//

import Firebase

class UserCollectionRepository {
    
    private let store = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    func addToUserCollection(collectionPath: String, documentId: String, user: User) {
        do {
            try store.collection(collectionPath).document(documentId).setData(from: user)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func get(collectionPath: String, id: String, completion: @escaping (User) -> Void) {
        
        let docRef = store.collection(collectionPath).document(id)

        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    completion(user)
                    print("Finish downloading user info")
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func addSingleDocumentToUserCollection(collectionPath: String, documentId: String, nameDocument: String, document: String) {
        store.collection(collectionPath).document(documentId).updateData([nameDocument: document]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Single document successfully written!")
            }
        }
    }
    
    func insertElementInArray(collectionPath: String, documentId: String, titleField: String, element: String) {
        store.collection(collectionPath).document(documentId).updateData([titleField: FieldValue.arrayUnion([element])])
    }
    
    func removeElementFromArray(collectionPath: String, documentId: String, titleField: String, element: String) {
        store.collection(collectionPath).document(documentId).updateData([titleField: FieldValue.arrayRemove([element])])
    }
    
    func uploadProfilePhotoToDatabase(storagePath: String, collectionPath: String, image: UIImage, documentId: String, nameField: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let storageRef =  storage.child(storagePath).child(documentId)
        
        if let imageData = image.jpegData(compressionQuality: 1) {
            storageRef.putData(imageData, metadata: nil) { (_, err) in
                if let err = err {
                    print("An error has occured - \(err.localizedDescription)")
                } else {
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            print(error?.localizedDescription as Any)
                            return
                        }
                        if let textUrl = url?.absoluteString {
                            self.addSingleFieldToUserCollection(collectionPath: collectionPath, documentId: documentId, nameField: nameField, field: textUrl)
                            completion(.success("Profile photo uploaded successfully as \(downloadURL)"))
                      }
                    }
                }
            }
        }
    }
    
    private func addSingleFieldToUserCollection(collectionPath: String, documentId: String, nameField: String, field: String) {
        store.collection(collectionPath).document(documentId).updateData([nameField: field]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Single document successfully written!")
            }
        }
    }
}
