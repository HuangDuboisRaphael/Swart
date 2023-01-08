//
//  AuthentificationViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/09/2021.
//

import SwiftUI

// Firebase methods related to user's authentification process and used in different views.
class AuthentificationViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var userId = UserId(id: "")
    @Published var pastUserId = UserId(id: "")
    
    private let authentificationRepository = AuthentificationRepository()
    
    // MARK: - Methods
    
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
    
    func userAlreadySignedIn() {
        authentificationRepository.userAlreadySignedIn { userId in
            if userId != "User not signed in yet." {
                self.pastUserId.id = userId
            }
        }
    }
    
    func logOutUser(completion: @escaping () -> Void) {
        authentificationRepository.logOutUser(completion: completion)
    }
    
    func forgotPassword(email: String, progress: @escaping (Result<String, Error>) -> Void) {
        authentificationRepository.forgotPassword(email: email, progress: progress)
    }
}
