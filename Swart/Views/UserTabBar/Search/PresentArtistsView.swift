//
//  PresentArtistsView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 11/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

// Fifth search view where all filtered artists are shown to user and has the possibility to select one for further details.
struct PresentArtistsView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @StateObject private var userCollectionViewModel = UserCollectionViewModel()
    @StateObject private var calendarViewModel = CalendarViewModel()
    @StateObject private var addressViewModel = AddressViewModel()
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    
    @Binding var selectedArtName: String
    @Binding var selectedDate: String
    @Binding var selectedDateForRequest: String
    @Binding var selectedPlaceName: String
    
    @State private var player = AVPlayer()
    @State private var selectedArtist = Artist(id: "", art: "", place: "", address: "", department: "", headline: "", textPresentation: "", profilePhoto: "", presentationVideo: "", artContentMedia: [], blockedDates: [], pendingRequest: [], comingRequest: [], previousRequest: [])
    @State private var selectedDateConverted = ""
    @State private var isLinkActive = false
    @State private var isShowMain = false
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Image("No Result")
                    .resizable()
                    .frame(width: 75, height: 75)
                
                Text("No artists have been found, please try to broaden your search").bold()
                    .font(Font.system(size: 18).italic())
                    .foregroundColor(.black).opacity(0.9)
                    .multilineTextAlignment(.center)
                
            }.isHidden(artistCollectionViewModel.artistsResult.count > 0 ? true : false)
            
            VStack {
                
                VStack {
                
                    HStack {
                        
                        Button {
                            isShowMain = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                artistCollectionViewModel.artistsResult.removeAll()
                            }
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.black).opacity(0.6)
                                .font(.system(size: 18))
                        }
                        
                        Text(selectedArtName).bold()
                            .foregroundColor(.black).opacity(0.6)
                            .font(.system(size: 18))
                            .isHidden(selectedArtName == "" ? true : false)
                        
                        Spacer()
                        
                        Text(selectedDateConverted).underline()
                            .foregroundColor(.black).opacity(0.4)
                            .font(.system(size: 17))
                            .isHidden(selectedDateConverted == "" ? true : false)
                        
                    }.padding(.horizontal, 20)
                    .padding(.top, 15)
                }
                
                Spacer()
                
                VStack {
                    
                    if artistCollectionViewModel.artistsResult.count == 1 {
                        Text(determineNumberOfResults() + " artist ready to amaze you")
                            .font(.system(size: 16)).bold()
                            .foregroundColor(.black)
                            .isHidden(artistCollectionViewModel.artistsResult.count > 0 ? false : true)
                    } else if artistCollectionViewModel.artistsResult.count > 1 {
                        Text(determineNumberOfResults() + " artists ready to amaze you")
                            .font(.system(size: 16)).bold()
                            .foregroundColor(.black)
                            .isHidden(artistCollectionViewModel.artistsResult.count > 0 ? false : true)
                    }
                        
                    Divider()
                        .padding(.top, 5)
                    
                }.padding(.top, 18)
    
                List(artistCollectionViewModel.artistsResult, id: \.self) { artist in
                    
                    VStack(alignment: .leading) {
                        
                        TabView {
                            
                            ForEach(artist.artContentMedia, id: \.self) { url in
                                
                                if url.contains("image") {
                                
                                    AnimatedImage(url: URL(string: url)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 335)
                                } else {
                                    VideoPlayer(player: player)
                                        .onAppear {
                                            player = AVPlayer(url: URL(string: url)!)
                                        }
                                }
                            }
                        }.tabViewStyle(PageTabViewStyle())
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text(artist.headline)
                                .foregroundColor(.black)
                                .font(.custom("ArialIMT", size: 19))
                                .lineLimit(1)
                            
                            Text("À " + addressViewModel.determineCity(address: artist.address) + " / " + addressViewModel.rewriteDepartment(department: artist.department))
                                .foregroundColor(.black).opacity(0.6)
                                .font(Font.system(size: 18).italic())
                                .lineLimit(1)
                                
                        }.padding(.horizontal, 12)
                        .padding(.top, -5)
                        
                        Spacer(minLength: 7)
                            
                    }.onTapGesture(perform: {
                        selectedArtist = artist
                        isLinkActive = true
                    })
                    .listRowBackground(Color.white)
                    .listRowSeparator(.hidden)
                }.background(NavigationLink("", destination: PreviewSelectedArtistView(userCollectionViewModel: userCollectionViewModel, selectedArtist: $selectedArtist, selectedDate: $selectedDateConverted, selectedDateForRequest: $selectedDateForRequest, selectedPlaceName: $selectedPlaceName), isActive: $isLinkActive))
                .environment(\.defaultMinListRowHeight, 315)
                .listStyle(GroupedListStyle())
                .isHidden(artistCollectionViewModel.artistsResult.count > 0 ? false : true)
            }.fullScreenCover(isPresented: $isShowMain) {
                UserTabView()
            }
            .onAppear {
                calendarViewModel.convertDateForPresentArtistView(selectedDate: selectedDate) { dateConverted in
                    selectedDateConverted = dateConverted
                }
                userCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "")
            }
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
    
    // MARK: - Method
    
    func determineNumberOfResults() -> String {
        let number = String(artistCollectionViewModel.artistsResult.count)
        return number
    }
}

struct PresentArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        PresentArtistsView(artistCollectionViewModel: ArtistCollectionViewModel(), selectedArtName: .constant(""), selectedDate: .constant(""), selectedDateForRequest: .constant(""), selectedPlaceName: .constant(""))
    }
}
