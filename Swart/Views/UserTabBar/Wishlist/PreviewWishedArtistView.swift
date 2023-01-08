//
//  PreviewWishedArtistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 29/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

// To preview selected favorite artist information, also the possibility to remove that artist from the wishlist.
// User can after book a performance date with that artist.
struct PreviewWishedArtistView: View {
    
    // MARK: - Properties
        
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @ObservedObject var wishlistViewModel: WishlistViewModel
    @ObservedObject var userCollectionViewModel: UserCollectionViewModel
    
    @Binding var selectedArtist: Artist
        
    @State private var showSheet = false
    @State private var removeFromWishlist = false
    @State private var selectedDate = ""
    @State private var hasSelectedADate = false
    @State private var selectedPlaceName = ""
    @State private var selectedDateForRequest = ""
    
    // MARK: - Body
        
    var body: some View {
        
        NavigationView {
            
            ZStack {
                    
                Color.white
                    .ignoresSafeArea()
                           
                VStack(alignment: .leading) {
                    
                    HStack {
                        
                        Button(action: {
                            if removeFromWishlist {
                                userCollectionViewModel.removeElementFromExistingArrayField(documentId: authentificationViewModel.userId.id ?? "", titleField: "wishlist", element: selectedArtist.id)
                                for artist in wishlistViewModel.wishedArtistsResult where artist.id.contains(selectedArtist.id) {
                                    let index = wishlistViewModel.wishedArtistsResult.firstIndex(of: artist)
                                    wishlistViewModel.wishedArtistsResult.remove(at: index!)
                                }
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }, label: {
                            BackwardChevron()
                        })
                            
                        Spacer()
                            
                        if !removeFromWishlist {
                            Button {
                                removeFromWishlist.toggle()
                            } label: {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.mainRed)
                                    .opacity(0.8)
                            }
                        } else {
                            Button {
                                removeFromWishlist.toggle()
                            } label: {
                                Image(systemName: "heart")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .opacity(0.8)
                            }
                        }
                    }.padding()
                    .padding(.horizontal, 2)
                    
                    CustomScrollViewToPreviewArtist(artContentMedia: selectedArtist.artContentMedia, headline: selectedArtist.headline, profilePhoto: selectedArtist.profilePhoto, presentationVideo: selectedArtist.presentationVideo, textPresentation: selectedArtist.textPresentation, address: selectedArtist.address)
                        .padding(.bottom, 60)
                }
                
                VStack {
                        
                    Spacer()
                    
                    CustomRectangleToPreviewArtist(selectedDate: $selectedDate, hasSelectedADate: hasSelectedADate, showSheet: $showSheet, userCollectionViewModel: userCollectionViewModel, selectedArtist: $selectedArtist, selectedDateForRequest: $selectedDateForRequest, selectedPlaceName: $selectedPlaceName)
                 
                }.onAppear {
                    if selectedArtist.place == "Audience's place" {
                        selectedPlaceName = "Your place"
                    } else {
                        selectedPlaceName = "Artist's place"
                    }
                }
            }.sheet(isPresented: $showSheet, content: {
                CheckArtistAvailabilityView(selectedArtist: $selectedArtist, selectedDate: $selectedDate, hasSelectedADate: $hasSelectedADate, showSheet: $showSheet, selectedDateForRequest: $selectedDateForRequest)
            })
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }.navigationViewStyle(.stack)
    }
}

struct PreviewWishedArtistView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWishedArtistView(wishlistViewModel: WishlistViewModel(), userCollectionViewModel: UserCollectionViewModel(), selectedArtist: .constant(Artist(id: "", art: "", place: "", address: "", department: "", headline: "", textPresentation: "", profilePhoto: "", presentationVideo: "", artContentMedia: [], blockedDates: [], pendingRequest: [], comingRequest: [], previousRequest: [])))
    }
}
