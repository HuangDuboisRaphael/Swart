//
//  UserInAuthentification.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/09/2021.
//

import FirebaseFirestoreSwift

// To store the UserId which will be called all over the views inside an environment object.
struct UserId {
    @DocumentID var id: String?
}
