//
//  ProfilePhotoView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 22/10/2021.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

// Fifth view for artist form where the future artist is proposed to add a profile photo but this is not mandatory.
// If photo added, it will be sent in firebase storage and its url in future artist personal document in firestore.
struct ProfilePhotoView: View {
    
    // MARK: - Properties
        
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @Binding var resetToRootView: Bool
    
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var isAlertDeletePhotoPresented = false
    @State private var isPhotoPresenting = false
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var imageSelected = UIImage()
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var url = ""
    @State private var initialText = ""
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                
                Spacer(minLength: 150)
                
                VStack(alignment: .leading, spacing: -20) {
                    
                    TitleForArtistForm(text: "Make your best smile")
                    
                    CaptionForArtistForm(text: "Adding a profile photo is not mandatory and can be done later. Nevertheless, it is highly recommended and will be appreciated by your future audience.")
                }
                
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                
                    VStack {
                    
                        ZStack {
                            
                            Color.lightGrayForBackground
                            
                            Button {
                                showActionSheet = true
                            } label: {
                                if isPhotoPresenting {
                                    Image(uiImage: imageSelected)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .padding(40)
                                } else {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .padding(40)
                                            
                                        Image(systemName: "person.crop.circle.badge.plus")
                                            .resizable()
                                            .frame(width: 100, height: 85)
                                            .foregroundColor(.mainRed)
                                        }
                                    }
                                }.padding()
                            }.actionSheet(isPresented: $showActionSheet) {
                                ActionSheet(title: Text("Add a photo to your profile."), message: nil, buttons: [
                                    .default(Text("Camera"), action: {
                                        self.showImagePicker = true
                                        self.sourceType = .camera
                                    }),
                                    .default(Text("Photo Library"), action: {
                                        self.showImagePicker = true
                                        self.sourceType = .photoLibrary
                                    }),
                                    .cancel()
                                ])
                            }.sheet(isPresented: $showImagePicker, onDismiss: didDismiss) {
                                ImagePicker(selectedImage: $imageSelected, sourceType: $sourceType)
                            }
                        
                        HStack {

                            Spacer()
                            
                            NavigationLink(destination: HeadlineView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button(action: {
                                    if isPhotoPresenting {
                                        artistCollectionViewModel.uploadProfilePhotoToDatabase(image: imageSelected, documentId: authentificationViewModel.userId.id ?? "", nameDocument: "profilePhoto") { result in
                                            switch result {
                                            case .success(let success):
                                                print(success)
                                            case .failure(let error):
                                                print(error.localizedDescription)
                                            }
                                        }
                                    } else {
                                        artistCollectionViewModel.addSingleFieldToArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameField: "profilePhoto", field: "")
                                    }
                                    self.isLinkActive = true
                                }, label: {
                                   textLabel()
                                })
                            }.isDetailLink(false)
                        }.padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Methods
    
    private func didDismiss() {
        if imageSelected.size.width != 0 {
            isPhotoPresenting = true
        } else {
            isPhotoPresenting = false
        }
    }
    
    private func textLabel() -> some View {
        return Group {
            if isPhotoPresenting {
                TextLabelNextForArtistForm()
            } else {
                TextLabelIgnoreForArtistForm()
            }
        }
    }
}

struct ArtistProfilePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoView(resetToRootView: .constant(false))
    }
}
