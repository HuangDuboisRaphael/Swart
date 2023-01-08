//
//  LivePhotoView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 17/10/2021.
//

import SwiftUI
import PhotosUI

// To set live photo representable.
struct LivePhotoView: UIViewRepresentable {
    var livePhoto: PHLivePhoto
    
    typealias UIViewType = PHLivePhotoView
    
    func makeUIView(context: Context) -> PHLivePhotoView {
        let livePhotoView = PHLivePhotoView()
        livePhotoView.livePhoto = livePhoto
        livePhotoView.startPlayback(with: .hint)
        return livePhotoView
    }
    
    func updateUIView(_ uiView: PHLivePhotoView, context: Context) {}
}
