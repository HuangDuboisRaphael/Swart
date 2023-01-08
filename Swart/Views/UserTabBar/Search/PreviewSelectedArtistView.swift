//
//  PreviewSelectedArtistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 25/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

// Sixth search view where the selected artist information are displayed, also the possibility to add the artist into user wishlist.
struct PreviewSelectedArtistView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @StateObject private var wishlistViewModel = WishlistViewModel()
    
    @ObservedObject var userCollectionViewModel: UserCollectionViewModel
    
    @Binding var selectedArtist: Artist
    @Binding var selectedDate: String
    @Binding var selectedDateForRequest: String
    @Binding var selectedPlaceName: String
    
    @State private var addToWhishlist = false
    @State private var showSheet = false
    @State private var hasSelectedADate = false
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
                   
            VStack(alignment: .leading) {
                
                HStack {
                
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        BackwardChevron()
                    })
                    
                    Spacer()
                    
                    if addToWhishlist {
                        Button {
                            addToWhishlist.toggle()
                        } label: {
                            Image(systemName: "heart.fill")
                             .font(.system(size: 20))
                             .foregroundColor(.mainRed)
                             .opacity(0.8)
                        }
                    } else {
                        Button {
                            addToWhishlist.toggle()
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
                    .padding(.bottom, 75)
            }
            
            VStack {
                
                Spacer()
                
                CustomRectangleToPreviewArtist(selectedDate: $selectedDate, hasSelectedADate: hasSelectedADate, showSheet: $showSheet, userCollectionViewModel: userCollectionViewModel, selectedArtist: $selectedArtist, selectedDateForRequest: $selectedDateForRequest, selectedPlaceName: $selectedPlaceName)
                
            }.sheet(isPresented: $showSheet, content: {
                CheckArtistAvailabilityView(selectedArtist: $selectedArtist, selectedDate: $selectedDate, hasSelectedADate: $hasSelectedADate, showSheet: $showSheet, selectedDateForRequest: $selectedDateForRequest)
            })
            .onDisappear {
                if addToWhishlist && !userCollectionViewModel.user.wishlist.contains(selectedArtist.id) {
                    userCollectionViewModel.insertElementInExistingArrayField(documentId: authentificationViewModel.userId.id ?? "", titleField: "wishlist", element: selectedArtist.id) {
                        userCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                            for wish in userCollectionViewModel.user.wishlist {
                                wishlistViewModel.getArtistsInWishlist(documentId: wish)
                            }
                        }
                    }
                } else if !addToWhishlist && userCollectionViewModel.user.wishlist.contains(selectedArtist.id) {
                    userCollectionViewModel.removeElementFromExistingArrayField(documentId: authentificationViewModel.userId.id ?? "", titleField: "wishlist", element: selectedArtist.id) {
                        userCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                            for wish in userCollectionViewModel.user.wishlist {
                                wishlistViewModel.getArtistsInWishlist(documentId: wish)
                            }
                        }
                    }
                }
            }
        }.onAppear(perform: {
            if selectedDate != "" {
                hasSelectedADate = true
            }
            if userCollectionViewModel.user.wishlist.contains(selectedArtist.id) {
                addToWhishlist = true
            }
        })
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct PreviewSelectedArtistView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewSelectedArtistView(userCollectionViewModel: UserCollectionViewModel(), selectedArtist: .constant(Artist(id: "", art: "", place: "", address: "", department: "", headline: "", textPresentation: "", profilePhoto: "", presentationVideo: "", artContentMedia: [], blockedDates: [], pendingRequest: [], comingRequest: [], previousRequest: [])), selectedDate: .constant(""), selectedDateForRequest: .constant(""), selectedPlaceName: .constant(""))
    }
}
