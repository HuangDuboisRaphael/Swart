//
//  AuthentificationRepository.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 16/02/2022.
//

import Firebase

// Firebase methods related to user's authentification process.
class AuthentificationRepository {
    
    // MARK: - Properties
    
    private let store = Firestore.firestore()
    private let userCollection = UserCollectionRepository()

    // MARK: - Methods
    
    func createUserInDatabase(email: String, password: String, rePassword: String, newUser: User, progressEmail: @escaping (Result<String, Error>) -> Void, completion: @escaping (String?) -> Void, collectionPath: String) {
        UserDefaults.standard.set(true, forKey: "registering")
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                progressEmail(.failure(error!))
            } else {
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    if error != nil {
                        progressEmail(.failure(error!))
                    } else {
                        progressEmail(.success("Welcome to Swart, we have sent you an email with your connection info !"))
                        if let user = authDataResult?.user {
                            completion(user.uid)
                            self.userCollection.addToUserCollection(collectionPath: collectionPath, documentId: user.uid, user: newUser)
                        }
                    }
                })
            }
        }
    }
    
    func signInUser(email: String, password: String, progress: @escaping (Result<String, Error>) -> Void, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                progress(.failure(error!))
            } else {
                if let user = authDataResult?.user {
                    progress(.success("Succeed to log in."))
                    completion(user.uid)
                }
            }
        }
    }
    
    func userAlreadySignedIn(completion: @escaping (String?) -> Void) {
        UserDefaults.standard.set(false, forKey: "registering")
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                completion(user.uid)
            } else {
                completion("User not signed in yet.")
            }
        }
    }
    
    func logOutUser(completion: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()
            completion()
        } catch {
            print("User already logged out.")
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
