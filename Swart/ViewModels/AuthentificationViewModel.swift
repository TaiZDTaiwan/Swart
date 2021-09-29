//
//  AuthentificationViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/09/2021.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class AuthentificationViewModel: ObservableObject {
    @Published var userInAuthentification = UserInAuthentification(id: "")
    
    private let store = Firestore.firestore()
    
    func addUserToDatabase(user: User) {
    
        store.collection("user").document(user.uid).setData(["email": user.email ?? ""]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
