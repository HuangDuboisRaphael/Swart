//
//  ArtistCollectionRepository.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 17/02/2022.
//

import Firebase
import SwiftUI

// Firebase methods to interact with artist properties in the database.
class ArtistCollectionRepository {
    
    // MARK: - Properties
    
    private let store = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    // MARK: - Methods
    
    func setArtistCollection(collectionPath: String, documentId: String, nameDocument: String, document: String) {
        store.collection(collectionPath).document(documentId).setData([nameDocument: document]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Single document successfully written!")
            }
        }
    }
    
    func get(collectionPath: String, documentId: String, completion: @escaping (Artist) -> Void) {
        let docRef = store.collection(collectionPath).document(documentId)
        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: Artist.self)
            }
            switch result {
            case .success(let artist):
                if let artist = artist {
                    completion(artist)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func removeUnfinishedArtistFromDatabase(collectionPath: String, documentId: String) {
        store.collection(collectionPath).document(documentId).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func isAlreadyAnArtist(collectionPath: String, documentId: String, completion: @escaping (Bool) -> Void) {
        let docRef = store.collection(collectionPath).document(documentId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                print(error?.localizedDescription as Any)
                completion(false)
            }
        }
    }
    
    func addSingleFieldToArtistCollection(collectionPath: String, documentId: String, nameField: String, field: String) {
        store.collection(collectionPath).document(documentId).updateData([nameField: field]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Single document successfully written!")
            }
        }
    }
    
    func addSingleArrayToArtistCollection(collectionPath: String, documentId: String, nameField: String, array: [String]) {
        store.collection(collectionPath).document(documentId).updateData([nameField: array]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Single document successfully written!")
            }
        }
    }
    
    func uploadArtContentVideosToDatabase(storagePath: String, documentId: String, localFile: URL, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let riversRef = storage.child(storagePath).child(documentId).child(fileName)
        let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { (_, error) in
            if let error = error {
                print("An error has occured - \(error)")
            } else {
                riversRef.downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription as Any)
                    } else {
                        if let textUrl = url?.absoluteString {
                            completion(.success(textUrl))
                            print("Video uploaded successfully")
                            
                        }
                    }
                }
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                print(completedUnitCount)
            }
        }
    }
    
    func uploadVideoPresentationToDatabase(storagePath: String, collectionPath: String, documentId: String, localFile: URL, nameDocument: String, completion: @escaping (Result<String, Error>) -> Void) {
        let riversRef = storage.child(storagePath).child(documentId)
        let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { (_, error) in
            if let error = error {
                print("An error has occured - \(error)")
            } else {
                riversRef.downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription as Any)
                    } else {
                        if let textUrl = url?.absoluteString {
                            self.addSingleFieldToArtistCollection(collectionPath: collectionPath, documentId: documentId, nameField: nameDocument, field: textUrl)
                        }
                    }
                }
                completion(.success("Video uploaded successfully"))
                print(localFile)
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                print(completedUnitCount)
            }
        }
    }
    
    func uploadProfilePhotoToDatabase(storagePath: String, collectionPath: String, documentId: String, image: UIImage, nameDocument: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let storageRef =  storage.child(storagePath).child(documentId)
        
        if let imageData = image.jpegData(compressionQuality: 1) {
            storageRef.putData(imageData, metadata: nil) { (_, err) in
                if let err = err {
                    print("An error has occured - \(err.localizedDescription)")
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print(error.localizedDescription as Any)
                        } else {
                            if let textUrl = url?.absoluteString {
                                self.addSingleFieldToArtistCollection(collectionPath: collectionPath, documentId: documentId, nameField: nameDocument, field: textUrl)
                            }
                        }
                    }
                    completion(.success("Image uploaded successfully"))
                }
            }
        }
    }
    
    func uploadArtContentImagesToDatabase(storagePath: String, documentId: String, fileName: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef =  storage.child(storagePath).child(documentId).child(fileName)
        if let imageData = image.jpegData(compressionQuality: 1) {
            storageRef.putData(imageData, metadata: nil) { (_, err) in
                if let err = err {
                    print("An error has occured - \(err.localizedDescription)")
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print(error.localizedDescription as Any)
                        } else {
                            if let textUrl = url?.absoluteString {
                                completion(.success(textUrl))
                                print("Image uploaded successfully")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteArtContentMediaFromStorage(storagePath: String, documentId: String, fileName: String, message: String, completion: @escaping (() -> Void)) {
        storage.child(storagePath).child(documentId).child(fileName).delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(message)
                completion()
            }
        }
    }
    
    func removeArtContentMediaFromDatabase(collectionPath: String, documentId: String, fieldName: String) {
        store.collection(collectionPath).document(documentId).updateData([fieldName: FieldValue.delete()]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Field successfully removed")
            }
        }
    }
    
    func insertElementInExistingArrayField(collectionPath: String, documentId: String, titleField: String, element: String) {
        store.collection(collectionPath).document(documentId).updateData([titleField: FieldValue.arrayUnion([element])])
    }
    
    func removeElementFromExistingArrayField(collectionPath: String, documentId: String, titleField: String, element: String) {
        store.collection(collectionPath).document(documentId).updateData([titleField: FieldValue.arrayRemove([element])])
    }
    
    func researchArtists(collectionPath: String, art: String? = nil, department: [String], place: String? = nil, completion: @escaping (Artist) -> Void) {
        var query = store.collection(collectionPath).whereField("department", in: department)
        
        if let art = art {
            query = query.whereField("art", isEqualTo: art)
        }
        
        if let place = place {
            query = query.whereField("place", isEqualTo: place)
        }
        
        query.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                        
                    let result = Result {
                        try document.data(as: Artist.self)
                    }
                    switch result {
                    case .success(let artist):
                        completion(artist)
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                }
            }
        }
    }
}
