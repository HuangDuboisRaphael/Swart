//
//  RequestType.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 15/02/2022.
//

import SwiftUI

// To quote the different request types.
enum RequestType {
    
    // The requests which haven't been validated by artists.
    case pending
    
    // The requests validated and will be performed in a near future.
    case coming
    
    // The requests which have been declined or already performed by artists.
    case previous
}
