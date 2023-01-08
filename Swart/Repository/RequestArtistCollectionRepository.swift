//
//  RequestArtistCollectionRepository.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 17/02/2022.
//

import Firebase

// Firebase methods to interact with request artist properties in the database.
class RequestArtistCollectionRepository {
    
    // MARK: - Properties
    
    private let store = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    // MARK: - Methods
    
    func addDocumentToRequestArtistCollection(collectionPath: String, request: RequestArtist, completion: @escaping (String) -> Void) {
        var reference: DocumentReference?
        do {
            reference = try store.collection(RequestArtistCollectionViewModel.collectionPath).addDocument(from: request) { err in
                if let err = err {
                    print("Error adding request: \(err)")
                } else {
                    completion(reference!.documentID)
                    print("Request added with ID: \(reference!.documentID)")
                }
            }
        } catch {
            print("Error writing request: \(error)")
        }
    }
    
    func getRequest(collectionPath: String, documentId: String, completion: @escaping (RequestArtist) -> Void) {
        let docRef = store.collection(collectionPath).document(documentId)
        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: RequestArtist.self)
            }
            switch result {
            case .success(let request):
                if let request = request {
                    completion(request)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func addIdToRequest(collectionPath: String, documentId: String) {
        let docRef = store.collection(collectionPath).document(documentId)
        docRef.updateData(["requestId": documentId]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func addUserIdToRequest(collectionPath: String, documentId: String, requestIdUser: String) {
        let docRef = store.collection(collectionPath).document(documentId)
        docRef.updateData(["requestIdUser": requestIdUser]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func acceptPendingRequest(collectionPath: String, documentId: String) {
        let docRef = store.collection(collectionPath).document(documentId)
        docRef.updateData(["accepted": true]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
