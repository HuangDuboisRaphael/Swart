//
//  ArtistTabView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/12/2021.
//

import SwiftUI

// Artist tab view where all artist's information are retrieved and communicated to child views: artist personal information and related requests.
// Also, coming requests which booking date is already passed are transferred to previous requests in the database.
struct ArtistTabView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    @StateObject private var requestArtistCollectionViewModel = RequestArtistCollectionViewModel()
    @StateObject private var calendarViewModel = CalendarViewModel()
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            TabView {
                ExperiencesArtistView(artistCollectionViewModel: artistCollectionViewModel, requestArtistCollectionViewModel: requestArtistCollectionViewModel)
                    .tabItem {
                        Image(systemName: "music.mic")
                        Text("Perfomances")
                }
            
                CalendarView(calendarViewModel: calendarViewModel)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                }
                
                ProfileArtistView(artistCollectionViewModel: artistCollectionViewModel)
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                }
            }.accentColor(.mainRed)
        }.onAppear {
            calendarViewModel.getBlockedDatesFromArtistDocument(documentId: authentificationViewModel.userId.id ?? "")
            artistCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                requestArtistCollectionViewModel.getRequests(pendingRequest: artistCollectionViewModel.artist.pendingRequest, comingRequest: artistCollectionViewModel.artist.comingRequest, previousRequest: artistCollectionViewModel.artist.previousRequest, documentId: authentificationViewModel.userId.id ?? "") {
                    artistCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                        requestArtistCollectionViewModel.retrieveRequests(pendingRequest: artistCollectionViewModel.artist.pendingRequest, comingRequest: artistCollectionViewModel.artist.comingRequest, previousRequest: artistCollectionViewModel.artist.previousRequest)
                    }
                }
            }
        }
    }
}

struct ArtistTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistTabView()
    }
}
