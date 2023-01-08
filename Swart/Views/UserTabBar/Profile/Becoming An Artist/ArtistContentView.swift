//
//  ArtisticalContentView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/11/2021.
//

import SwiftUI
import AVKit
import PhotosUI
import ActivityIndicatorView

// Ninth view for artist form where the future artist is asked to upload at least 5 photos or videos which describe the best his art.
// When media confirmed, it will be sent in firebase storage and its url in future artist personal document in firestore.
struct ArtistContentView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    @StateObject private var mediaItems = PhotoPickerViewModel()

    @Binding var resetToRootView: Bool
    
    @State private var filter: PHPickerFilter = .any(of: [.images, .livePhotos, .videos])
    @State private var selectionLimit = 0
    @State private var showSheet = false
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isPresented = false
    @State private var isEditing = false
    @State private var image = UIImage()
    @State private var isLoading = false
    @State private var downloadedPercentage = 0.0
    @State private var percentageToAdd = 0.0
    @State private var downloadIsOver = false
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            BackgroundForArtistForm()
                
            CustomArtContentProgressView(downloadedPercentage: $downloadedPercentage, percentageToAdd: $percentageToAdd, downloadIsOver: $downloadIsOver, isLoading: $isLoading)
                    
            VStack(alignment: .leading) {
                
                HStack {
                    BackButtonForArtistForm(presentationMode: _presentationMode)
                    
                    Spacer()
                    
                    if mediaItems.items.isEmpty {
                        DismissButtonForArtistForm(isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                    } else {
                        EditButton()
                            .foregroundColor(.black)
                            .padding()
                    }
                }.padding(.horizontal, 5)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: -20) {
                    
                    TitleForArtistForm(text: "Finally, let us admire your art!")
                    
                    CaptionForArtistForm(text: "Add at least 5 photos or videos in your chosen order which describe your artistical talent the best")
                }
                
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                
                    VStack {
                    
                        ZStack {
                            
                            Color.lightGrayForBackground
                            
                            Image("ArtBackground")
                                .resizable()
                                .isHidden(mediaItems.items.isEmpty ? false : true)
                            
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
                            .isHidden(mediaItems.items.isEmpty ? true : false)
                            .sheet(isPresented: $showSheet, content: {
                                MediaPicker(mediaItems: mediaItems, filter: $filter, selectionLimit: $selectionLimit) { _ in
                                    showSheet = false
                                }
                            })
                        }
                    
                        HStack {
                            Button {
                                showSheet = true
                            } label: {
                                ImageForVideoPresentationView(text: "plus")
                                    .foregroundColor(.black)
                            }

                            Spacer()
                            
                            NavigationLink(destination: ReviewProfileView(artistCollectionViewModel: artistCollectionViewModel, resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button {
                                    isLoading = true
                                    artistCollectionViewModel.uploadArtContentMediaToStorage(mediaItems: mediaItems.items, documentId: authentificationViewModel.userId.id ?? "") { percentage in
                                        percentageToAdd += percentage
                                    } completionHandler: {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                            downloadIsOver = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                isLinkActive = true
                                                isLoading = false
                                            }
                                        }
                                    }
                                } label: {
                                    ReviewAndSaveButtonForArtistForm(text: "Review profile")
                                }
                            }.isDetailLink(false)
                            .isHidden(mediaItems.items.count > 4 ? false : true)
                        }.padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
            }.isHidden(isLoading ? true : false)
            .sheet(isPresented: $isPresented) {
                MediaPicker(mediaItems: mediaItems, filter: $filter, selectionLimit: $selectionLimit) { _ in
                    isPresented = false
                }
            }
        }.onAppear(perform: {
            downloadedPercentage = 0
            percentageToAdd = 0
            downloadIsOver = false
        })
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

struct ArtisticalContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistContentView(resetToRootView: .constant(false))
    }
}
