//
//  UserRepositoryViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/09/2021.
//

import SwiftUI

// Various methods to interact with user properties in the database or other properties in different views.
class UserCollectionViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var user = User(firstName: "", lastName: "", birthdate: "", address: "", department: "", email: "", profilePhoto: "", wishlist: [], pendingRequest: [], comingRequest: [], previousRequest: [])
    
    static let collectionPath = "user"
    static let storagePathUserProfilePhoto = "users_profile_photos"
    private let userCollectionRepository = UserCollectionRepository()
    
    // MARK: - Methods
    
    func addDocumentToUserCollection(documentId: String, user: User, completion: @escaping (() -> Void)) {
        userCollectionRepository.addToUserCollection(collectionPath: UserCollectionViewModel.collectionPath, documentId: documentId, user: user)
        completion()
    }
    
    func get(documentId: String, completion: (() -> Void)? = nil) {
        userCollectionRepository.get(collectionPath: UserCollectionViewModel.collectionPath, id: documentId) { user in
            self.user = user
            completion?()
        }
    }
    
    func addSingleFieldToUserCollection(documentId: String, nameField: String, field: String) {
        userCollectionRepository.addSingleFieldToUserCollection(collectionPath: UserCollectionViewModel.collectionPath, documentId: documentId, nameField: nameField, field: field)
    }

    func insertElementInExistingArrayField(documentId: String, titleField: String, element: String, completion: (() -> Void)? = nil) {
        userCollectionRepository.insertElementInExistingArrayField(collectionPath: UserCollectionViewModel.collectionPath, documentId: documentId, titleField: titleField, element: element)
        completion?()
    }
    
    func removeElementFromExistingArrayField(documentId: String, titleField: String, element: String, completion: (() -> Void)? = nil) {
        userCollectionRepository.removeElementFromExistingArrayField(collectionPath: UserCollectionViewModel.collectionPath, documentId: documentId, titleField: titleField, element: element)
        completion?()
    }
    
    func uploadProfilePhotoToDatabase(image: UIImage, documentId: String, nameField: String, completion: @escaping (Result<String, Error>) -> Void) {
        userCollectionRepository.uploadProfilePhotoToDatabase(storagePath: "users_profile_photos", collectionPath: UserCollectionViewModel.collectionPath, image: image, documentId: documentId, nameDocument: nameField, completion: completion)
    }
    
    func addAddressInformationToDatabase(documentId: String, documentAddress: String, documentDepartment: String, completion: @escaping (() -> Void)) {
        self.addSingleFieldToUserCollection(documentId: documentId, nameField: "address", field: documentAddress)
        self.addSingleFieldToUserCollection(documentId: documentId, nameField: "department", field: documentDepartment)
        completion()
    }
}
