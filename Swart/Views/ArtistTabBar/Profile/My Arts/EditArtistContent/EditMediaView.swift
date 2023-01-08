//
//  EditMediaView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/12/2021.
//

import SwiftUI
import AVKit
import PhotosUI

// To edit artist's art content media. To do so, the artist needs to upload at least five photos or videos.
// Once confirmed, it would replace old media urls in storage and firestore.
struct EditMediaView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var mediaItems = PhotoPickerViewModel()
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    
    @State private var filter: PHPickerFilter = .any(of: [.images, .livePhotos, .videos])
    @State private var selectionLimit = 0
    @State private var showSheet = false
    @State private var isEditing = false
    @State private var isLoading = false
    @State private var downloadedPercentage = 0.0
    @State private var percentageToAdd = 0.0
    @State private var downloadIsOver = false
    @State private var hasEdited = false
    @State private var isAboveFive = false
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            if isLoading {
                BackgroundForArtistForm()
            } else {
                Color.white
                    .ignoresSafeArea()
            }
            
            CustomArtContentProgressView(downloadedPercentage: $downloadedPercentage, percentageToAdd: $percentageToAdd, downloadIsOver: $downloadIsOver, isLoading: $isLoading)
            
            VStack {
                
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        BackwardChevron()
                            .padding()
                    })
                    
                    Spacer()
                    
                    EditButton()
                        .foregroundColor(.black)
                        .padding()
                        .isHidden(hasEdited ? false : true)
                }
                
                VStack(alignment: .leading) {
                    Text("Photos / Videos")
                        .font(.title).bold()
                        .foregroundColor(.black)
            
                    ZStack {
                        Color.lightGrayForBackground
                            .isHidden(hasEdited ? false : true)
                         
                        ZStack {
                            Text("Insert at least 5 new photos or videos in your chosen order which describe your artistical talent the best. This action will replace your previous artistical content.")
                                .font(.subheadline).italic()
                                .isHidden(hasEdited ? true : false)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            
                            List {
                                ForEach(mediaItems.items, id: \.id) { item in
                                    DetermineMediaItem(item: item)
                                }.onMove(perform: move)
                                .onDelete(perform: mediaItems.deleteItemAtGivenIndex)
                                .onLongPressGesture {
                                    withAnimation {
                                        isEditing = true
                                    }
                                }
                            }.padding(.horizontal, 10)
                            .isHidden(hasEdited ? false : true)
                            .sheet(isPresented: $showSheet, content: {
                                MediaPicker(mediaItems: mediaItems, filter: $filter, selectionLimit: $selectionLimit) { _ in
                                    showSheet = false
                                }
                            })
                        }
                    }
                    
                    HStack {
                        Button {
                            showSheet = true
                        } label: {
                            ImageForVideoPresentationView(text: "plus")
                                .foregroundColor(.mainRed)
                                .padding(.vertical, 10)
                        }
                        
                        Spacer()
                        
                        Button {
                            isLoading = true
                            artistCollectionViewModel.deleteArtContentMediaFromStorage(documentId: authentificationViewModel.userId.id ?? "") {
                                artistCollectionViewModel.removeArtContentMediaFromDatabase(documentId: authentificationViewModel.userId.id ?? "") {
                                    artistCollectionViewModel.uploadArtContentMediaToStorage(mediaItems: mediaItems.items, documentId: authentificationViewModel.userId.id ?? "") { percentage in
                                        percentageToAdd += percentage
                                    } completionHandler: {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                            downloadIsOver = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                presentationMode.wrappedValue.dismiss()
                                                isLoading = false
                                            }
                                        }
                                    }
                                }
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 2)
                                    .frame(width: 75, height: 35)
                                    .foregroundColor(.mainRed)
                                    .opacity(isAboveFive ? 1 : 0.2)
                                    
                                Text("Save")
                                    .font(.system(size: 18)).bold()
                                    .foregroundColor(.white)
                            }
                        }.padding(.vertical, 10)
                        .disabled(isAboveFive ? false : true)
                    }
                }.padding(.horizontal, 20)
            }.isHidden(isLoading ? true : false)
            .onReceive(timer) { _ in
                if mediaItems.items.count > 0 {
                    hasEdited = true
                } else {
                    hasEdited = false
                }
                if mediaItems.items.count >= 5 {
                    isAboveFive = true
                } else {
                    isAboveFive = false
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Method
    
    private func move(fromOffsets source: IndexSet, toOffsets destination: Int) {
        mediaItems.items.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            isEditing = false
        }
    }
}

struct EditMediaView_Previews: PreviewProvider {
    static var previews: some View {
        EditMediaView(artistCollectionViewModel: ArtistCollectionViewModel())
    }
}
