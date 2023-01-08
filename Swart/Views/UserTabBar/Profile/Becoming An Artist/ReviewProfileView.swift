//
//  ItemsView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 16/10/2021.
//

import SwiftUI
import AVKit
import PhotosUI
import SDWebImageSwiftUI

// Last view for artist form where all previous information are displayed, once confirmed, the user is becoming an artist, can receive booking requests and have accessed to artist tab view.
struct ReviewProfileView: View {
    
    // MARK: - Properties

    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    
    @Binding var resetToRootView: Bool

    @State private var isAlertDismissPresented = false
    @State private var isLinkActive = false
    @State private var showArtistTabBar = false
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
                    
            VStack(alignment: .leading) {
                
                HStack {
                    Button {
                        artistCollectionViewModel.deleteArtContentMediaFromStorage(documentId: authentificationViewModel.userId.id ?? "") {
                            artistCollectionViewModel.removeArtContentMediaFromDatabase(documentId: authentificationViewModel.userId.id ?? "") {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        HStack(spacing: -12) {
                            BackwardChevron()
                                .padding()
                            
                            Text("Back")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                    }.alert(isPresented: $isAlertDismissPresented) {
                        Alert(
                            title: Text("You are about to undo current artist form."),
                            message: .none,
                            primaryButton: .destructive(Text("Confirm")) {
                                self.resetToRootView = false
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isAlertDismissPresented.toggle()
                    }, label: {
                        Image(systemName: "clear")
                            .foregroundColor(.black)
                            .opacity(0.8)
                            .padding()
                    })
                }.padding(.horizontal, 5)
                
                CustomScrollViewToPreviewArtist(artContentMedia: artistCollectionViewModel.artist.artContentMedia, headline: artistCollectionViewModel.artist.headline, profilePhoto: artistCollectionViewModel.artist.profilePhoto, presentationVideo: artistCollectionViewModel.artist.presentationVideo, textPresentation: artistCollectionViewModel.artist.textPresentation, address: artistCollectionViewModel.artist.address)
            }
                
            VStack {
                        
                Spacer()
                        
                Rectangle()
                    .ignoresSafeArea(edges: .bottom)
                    .frame(height: 70)
                    .foregroundColor(.white)
                    .border(width: 0.7, edges: [.top], color: .gray.opacity(0.3))
                    .overlay(
                        HStack {
                            Spacer()
                                    
                            Button(action: {
                                self.showArtistTabBar = true
                            }, label: {
                                ReviewAndSaveButtonForArtistForm(text: "Save profile")
                            })
                        }.padding(.horizontal, 27)
                        .padding(.top, 8))
            }
        }.fullScreenCover(isPresented: $showArtistTabBar, content: {
            ArtistTabView()
        })
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ReviewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewProfileView(artistCollectionViewModel: ArtistCollectionViewModel(), resetToRootView: .constant(false))
            .environmentObject(AuthentificationViewModel())
    }
}
