//
//  DatabaseError.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 27/03/2022.
//

import SwiftUI

enum DatabaseError: Error {
    case firestoreError
    case storageError
}
