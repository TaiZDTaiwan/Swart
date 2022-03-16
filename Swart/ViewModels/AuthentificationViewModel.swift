//
//  AuthentificationViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/09/2021.
//

import SwiftUI

class AuthentificationViewModel: ObservableObject {
    
    @Published var userId = UserId(id: "")
    
    let authentificationRepository = AuthentificationRepository()
    
    func createUserInDatabase(email: String, password: String, rePassword: String, newUser: User, progressEmail: @escaping (Result<String, Error>) -> Void) {
        authentificationRepository.createUserInDatabase(email: email, password: password, rePassword: rePassword, newUser: newUser, progressEmail: progressEmail, completion: { userId in
            self.userId.id = userId
        }, collectionPath: UserCollectionViewModel.collectionPath)
    }
    
    func signInUser(email: String, password: String, progress: @escaping (Result<String, Error>) -> Void) {
        authentificationRepository.signInUser(email: email, password: password, progress: progress, completion: { userId in
            self.userId.id = userId
        })
    }
    
    func forgotPassword(email: String, progress: @escaping (Result<String, Error>) -> Void) {
        authentificationRepository.forgotPassword(email: email, progress: progress)
    }
}
