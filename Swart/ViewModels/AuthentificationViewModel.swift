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
    
    let userCollectionViewModel = UserCollectionViewModel()
    
    private let store = Firestore.firestore()

    func createUserInDatabase(email: String, password: String, rePassword: String, newUser: User, progress: @escaping (Result<String, Error>) -> Void, progressEmail: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                progress(.failure(error!))
            } else if password != rePassword {
                progress(.success("Please insert same passwords."))
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        if error != nil {
                            progressEmail(.failure(error!))
                        } else {
                            progressEmail(.success("Welcome to Swart, we have sent you an email with your connection info !"))
                            if let user = authDataResult?.user {
                                self.userInAuthentification.id = user.uid
                                self.userCollectionViewModel.addToUserCollection(id: self.userInAuthentification.id ?? "", user: newUser)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func signInUser(email: String, password: String, progress: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                progress(.failure(error!))
            } else {
                if let user = authDataResult?.user {
                    progress(.success("Succeed to log in."))
                    self.userInAuthentification.id = user.uid
                }
            }
        }
    }
    
    func forgotPassword(email: String, progress: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil {
                progress(.failure(error!))
            } else {
                progress(.success("A link to restaure your password has been sent to your mailbox."))
            }
        }
    }
}
