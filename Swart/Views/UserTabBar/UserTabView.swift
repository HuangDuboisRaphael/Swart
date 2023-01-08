//
//  UserTabView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 05/09/2021.
//

import SwiftUI

// User tab view where all user's information are retrieved and communicated to child views: user personal information, user artists wishlist and related requests.
// Also, coming requests which booking date is already passed are transferred to previous requests in the database.

struct UserTabView: View {
    
    // MARK: - Properties
    
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @StateObject private var userCollectionViewModel = UserCollectionViewModel()
    @StateObject private var requestUserCollectionViewModel = RequestUserCollectionViewModel()
    @StateObject private var wishlistViewModel = WishlistViewModel()
        
    // MARK: - Body
    
    var body: some View {
        
        TabView {
        
            SearchArtistView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
            }
            
            WishlistView(wishlistViewModel: wishlistViewModel, userCollectionViewModel: userCollectionViewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Wishlist")
            }
            
            ExperiencesView(userCollectionViewModel: userCollectionViewModel, requestUserCollectionViewModel: requestUserCollectionViewModel)
                .tabItem {
                    Image(systemName: "wand.and.stars")
                    Text("Experiences")
            }
            
            ProfileUserView(userCollectionViewModel: userCollectionViewModel)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
            }
        }.accentColor(.mainRed)
        .onAppear {
            if authentificationViewModel.pastUserId.id != "" {
                authentificationViewModel.userId.id = authentificationViewModel.pastUserId.id
            }
            
            if colorScheme == .dark {
                UITabBar.appearance().backgroundColor = UIColor.white
            }
            
            userCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                for wish in userCollectionViewModel.user.wishlist {
                    wishlistViewModel.getArtistsInWishlist(documentId: wish)
                }
                
                requestUserCollectionViewModel.getRequests(pendingRequest: userCollectionViewModel.user.pendingRequest, comingRequest: userCollectionViewModel.user.comingRequest, previousRequest: userCollectionViewModel.user.previousRequest, documentId: authentificationViewModel.userId.id ?? "") {
                    userCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                        requestUserCollectionViewModel.retrieveRequests(pendingRequest: userCollectionViewModel.user.pendingRequest, comingRequest: userCollectionViewModel.user.comingRequest, previousRequest: userCollectionViewModel.user.previousRequest)
                    }
                }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView()
    }
}
