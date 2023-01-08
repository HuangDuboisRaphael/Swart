//
//  PhotoPicker.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 18/02/2022.
//

import SwiftUI
import Photos

// To store the various media elements submitted.
struct Media: Identifiable, Equatable {
    
    enum MediaType {
        case photo, video, livePhoto
    }
    
    var id: String
    var photo: UIImage?
    var url: URL?
    var livePhoto: PHLivePhoto?
    var mediaType: MediaType = .photo
    
    init(with photo: UIImage) {
        id = UUID().uuidString
        self.photo = photo
        mediaType = .photo
    }
    
    init(with videoURL: URL) {
        id = UUID().uuidString
        url = videoURL
        mediaType = .video
    }
    
    init(with livePhoto: PHLivePhoto) {
        id = UUID().uuidString
        self.livePhoto = livePhoto
        mediaType = .livePhoto
    }
    
    mutating func delete() {
        switch mediaType {
        case .photo:
            photo = nil
        case .livePhoto:
            livePhoto = nil
        case .video:
            guard let url = url else { return }
            try? FileManager.default.removeItem(at: url)
            self.url = nil
        }
    }
}
