//
//  MyArtsView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 02/12/2021.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

// Display all related art information and possibility to select one for editing.
struct MyArtsView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.white
                    .ignoresSafeArea()
            
                VStack(alignment: .leading) {
                
                    ScrollView {
                        
                        VStack(alignment: .leading, spacing: 40) {
                            
                            VStack(alignment: .leading, spacing: 5) {
                                
                                HStack {
                                    Text("About your art")
                                        .font(.title).bold()
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    NavigationLink {
                                        PreviewArtView(artistCollectionViewModel: artistCollectionViewModel)
                                    } label: {
                                        Text("Preview")
                                            .foregroundColor(.blue).opacity(0.7)
                                            .font(.system(size: 14))
                                    }
                                }
                                
                                Text("Users can see this info before they book")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                            
                            VStack(alignment: .leading, spacing: 25) {
                                
                                VStack(alignment: .leading, spacing: 15) {
                                
                                    NavigationLink {
                                        EditMediaView(artistCollectionViewModel: artistCollectionViewModel)
                                    } label: {
                                        HStack {
                                            Text("Photos / Videos")
                                                .foregroundColor(.black).opacity(0.9)
                                                .font(.system(size: 18))
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.black).opacity(0.7)
                                        }
                                    }
                                        
                                    ScrollView(.horizontal) {
                                            
                                        HStack {
                                            
                                            ForEach(artistCollectionViewModel.artist.artContentMedia, id: \.self) { url in
                                                    
                                                if url.contains("image") {
                                                    Rectangle()
                                                        .frame(width: 150, height: 100)
                                                        .foregroundColor(.lightGrayForBackground)
                                                        .overlay(AnimatedImage(url: URL(string: url))
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .fixedSize(horizontal: false, vertical: true))
                                                    
                                                } else if url.contains("video") {
                                                    VideoPlayer(player: AVPlayer(url: URL(string: url)!))
                                                        .frame(height: 100)
                                                        .frame(width: 150)
                                                }
                                            }
                                        }
                                    }
                                }
                                CustomVStackForMyArtsView(view: AnyView(EditHeadlineView(artistCollectionViewModel: artistCollectionViewModel)), title: "Headline", content: artistCollectionViewModel.artist.headline)
                                
                                CustomVStackForMyArtsView(view: AnyView(EditTextPresentationView(artistCollectionViewModel: artistCollectionViewModel)), title: "Presentation", content: artistCollectionViewModel.artist.textPresentation)
                                    .lineLimit(2)
                                
                                CustomVStackForMyArtsView(view: AnyView( EditLocationView(artistCollectionViewModel: artistCollectionViewModel)), title: "Location", content: artistCollectionViewModel.artist.address)
                            }
                        }.padding(.horizontal, 20)
                    }.padding(.vertical, 10)
                }.padding(.vertical, 5)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            BackwardChevron()
                        })
                    }
                }
            }
        }.navigationViewStyle(.stack)
    }
}

struct MyArtsView_Previews: PreviewProvider {
    static var previews: some View {
        MyArtsView(artistCollectionViewModel: ArtistCollectionViewModel())
    }
}

// MARK: - Refactoring structure

struct CustomVStackForMyArtsView: View {
    var view: AnyView
    var title: String
    var content: String
    
    var body: some View {
        
        Divider()
        
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink {
                view
            } label: {
                HStack {
                    Text(title)
                        .foregroundColor(.black).opacity(0.9)
                        .font(.system(size: 18))
                        
                    Spacer()
                        
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black).opacity(0.7)
                }
            }
            Text(content)
                .foregroundColor(.black).opacity(0.7)
                .font(.system(size: 16))
        }
    }
}
