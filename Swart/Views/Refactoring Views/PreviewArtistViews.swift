//
//  PreviewArtistViews.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 02/03/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

// Refactoring structures using in preview artist views.
struct CustomScrollViewToPreviewArtist: View {
    
    @State private var player = AVPlayer()
    @State private var presentVideoSheet = false
    @State private var currentElement = ""
    
    var artContentMedia: [String]
    var headline: String
    var profilePhoto: String
    var presentationVideo: String
    var textPresentation: String
    var address: String
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: -66) {
                    
                List {
        
                    TabView {
                            
                        ForEach(artContentMedia, id: \.self) { url in
                            
                            if url.contains("image") {
                                AnimatedImage(url: URL(string: url))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 320)
                                    .onAppear {
                                        currentElement = url
                                    }
       
                            } else if url.contains("video") {
                                VideoPlayer(player: player)
                                    .frame(height: 320)
                                    .frame(maxWidth: .infinity)
                                    .onAppear {
                                        currentElement = url
                                        player = AVPlayer(url: URL(string: url)!)
                                    }
                            }
                        }
                    }.listRowBackground(Color.white)
                    .tabViewStyle(PageTabViewStyle())
                }.frame(height: 320)
                .environment(\.defaultMinListRowHeight, 220)
                .padding(.top, -45)
                .onAppear(perform: {
                    UITableView.appearance().backgroundColor = .white
                })
            
                VStack(spacing: 15) {
                
                    HStack {
            
                        Text(headline)
                            .font(.system(size: 21)).bold()
                            .foregroundColor(.black)
                
                            Spacer()
                    
                        Button {
                            presentVideoSheet = true
                        } label: {
                            ZStack {
                                AnimatedImage(url: URL(string: profilePhoto))
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .isHidden(profilePhoto == "" ? true : false)
                            
                                Image(systemName: "play.fill")
                                    .foregroundColor(profilePhoto == "" ? .black : .white)
                                    .opacity(0.7)
                                    .isHidden(presentationVideo == "" ? true : false)
                            }
                        }.disabled(presentationVideo == "" ? true : false)
                        .padding(.top, 8)
                    }.padding(.top, 18)
                
                    Divider()
                
                    HStack {
                        Text(textPresentation)
                            .foregroundColor(.black)
                    
                        Spacer()
                    }
                
                    Divider()
                
                    VStack(spacing: 6) {
                        DisplayInformationInReviewProfileView(text: Text("Location"))
                            .font(.headline)
                            .foregroundColor(.black)
                           
                        DisplayInformationInReviewProfileView(text: Text(address))
                            .font(.system(size: 18))
                            .padding(.top, 6)
                            .foregroundColor(.black)
                        
                        DisplayInformationInReviewProfileView(text: Text("We'll only share your address with guests who are booked as outlined in our ").font(.footnote) + Text("privacy policy.").underline()).font(.footnote).foregroundColor(.black)
                    }
                }.padding(.horizontal, 39)
            }.onChange(of: currentElement) { _ in
                player.pause()
            }
        }
        .sheet(isPresented: $presentVideoSheet, content: {
            VideoPlayer(player: AVPlayer(url: URL(string: presentationVideo)!))
        })
    }
}

struct CustomRectangleToPreviewArtist: View {
    
    @Binding var selectedDate: String
    var hasSelectedADate: Bool
    @Binding var showSheet: Bool
    var userCollectionViewModel: UserCollectionViewModel
    @Binding var selectedArtist: Artist
    @Binding var selectedDateForRequest: String
    @Binding var selectedPlaceName: String
    
    var body: some View {
        
        Rectangle()
            .ignoresSafeArea(edges: .bottom)
            .frame(height: 70)
            .foregroundColor(.white)
            .border(width: 0.7, edges: [.top], color: .gray.opacity(0.3))
            .overlay(
                HStack {
                    
                    Text(selectedDate).underline()
                        .font(.system(size: 16))
                        .padding(.top, 10)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if !hasSelectedADate {
                        Button {
                            showSheet = true
                        } label: {
                            Text("Check availability").bold()
                                .frame(width: 135, height: 9, alignment: .center)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(.mainRed).opacity(0.8))
                                .padding(.top, 2)
                        }
                    } else {
                        NavigationLink {
                            RequestToBookView(userCollectionViewModel: userCollectionViewModel, selectedArtist: $selectedArtist, selectedDate: $selectedDate, selectedDateForRequest: $selectedDateForRequest, selectedPlaceName: $selectedPlaceName)
                        } label: {
                            Text("Reserve").bold()
                                .frame(width: 100, height: 12, alignment: .center)
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(.mainRed).opacity(0.8))
                                .padding(.top, 2)
                        }
                    }
                }.padding(.horizontal, 27))
    }
}

struct DisplayInformationInReviewProfileView: View {
    
    var text: Text
    
    var body: some View {
        HStack {
            text
            
            Spacer()
        }
    }
}
