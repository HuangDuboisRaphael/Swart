//
//  PreviewArtView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 03/12/2021.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

// All related art information are displayed the way users would observe it when searching for artists.
struct PreviewArtView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
                    
            VStack(alignment: .leading) {
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    BackwardChevron()
                        .padding()
                })
                
                CustomScrollViewToPreviewArtist(artContentMedia: artistCollectionViewModel.artist.artContentMedia, headline: artistCollectionViewModel.artist.headline, profilePhoto: artistCollectionViewModel.artist.profilePhoto, presentationVideo: artistCollectionViewModel.artist.presentationVideo, textPresentation: artistCollectionViewModel.artist.textPresentation, address: artistCollectionViewModel.artist.address)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
