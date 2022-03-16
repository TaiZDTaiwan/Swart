//
//  CalendarRepository.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 18/02/2022.
//

import Firebase

class CalendarRepository {
    
    private let store = Firestore.firestore()
    
    func uploadBlockedDates(collectionPath: String, documentId: String, dates: [String], completion: @escaping (() -> Void)) {
        let docRef =  store.collection(collectionPath).document(documentId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                for date in dates {
                    docRef.updateData(["blockedDates": FieldValue.arrayUnion([date])])
                    completion()
                }
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func deleteBlockedDates(collectionPath: String, documentId: String, dates: [String], completion: @escaping (() -> Void)) {
        let docRef =  store.collection(collectionPath).document(documentId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                for date in dates {
                    docRef.updateData(["blockedDates": FieldValue.arrayRemove([date])])
                    completion()
                }
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func getBlockedDates(collectionPath: String, documentId: String, completion: @escaping ([String]) -> Void) {
        let docRef =  store.collection(collectionPath).document(documentId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("blockedDates") as? [String] ?? [])
            } else {
                print("Document does not exist: " + "\(String(describing: error?.localizedDescription))")
            }
        }
    }
}
