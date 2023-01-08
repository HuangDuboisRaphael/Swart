//
//  ProfileView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 08/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

// Fourth user tab where user can edit his personal information and add a profile photo, become an artist by filling a form, navigate to the artist tab view if form already filled or possibility to log out and return to HomeView.
struct ProfileUserView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @ObservedObject var userCollectionViewModel: UserCollectionViewModel
    
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var imageSelected = UIImage()
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var isShownBecomeAnArtistHomePageView = false
    @State private var isShownArtistTabView = false
    @State private var isShownParametersView = false
    @State private var isShownHomePage = false
    @State private var isAlertPresented = false
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.white
                    .ignoresSafeArea()
            
                VStack {
                    
                    HStack {
                       
                        Button {
                            showActionSheet = true
                        } label: {
                            if imageSelected.size.width != 0 {
                                Image(uiImage: imageSelected)
                                    .resizable()
                                    .modifier(ModifierForImageInProfileUserView())
                            } else {
                                if userCollectionViewModel.user.profilePhoto != "" {
                                    AnimatedImage(url: URL(string: userCollectionViewModel.user.profilePhoto))
                                        .resizable()
                                        .modifier(ModifierForImageInProfileUserView())
                                } else {
                                    ZStack {
                                        Image("profileImage")
                                            .resizable()
                                            .modifier(ModifierForImageInProfileUserView())
                                            
                                        Image(systemName: "plus")
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.black)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }.padding()
                        
                        Text(userCollectionViewModel.user.firstName)
                            .foregroundColor(.black)
                            .bold()
                            .font(.title)
                            
                        Spacer()
                        
                    }.actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("Add a photo to your profile."), message: nil, buttons: [
                            .default(Text("Camera"), action: {
                                showImagePicker = true
                                sourceType = .camera
                            }),
                            .default(Text("Photo Library"), action: {
                                showImagePicker = true
                                sourceType = .photoLibrary
                            }),
                            .cancel()
                        ])
                    }.sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $imageSelected, sourceType: $sourceType)
                    }
                    Spacer()
                }.onDisappear {
                    if imageSelected.size.width != 0 {
                        userCollectionViewModel.uploadProfilePhotoToDatabase(image: imageSelected, documentId: authentificationViewModel.userId.id ?? "", nameField: "profilePhoto") { result in
                            switch result {
                            case .success(let success):
                                print(success)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 30) {
            
                    Text("ACCOUNT PARAMETERS")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .bold()
                    
                    Button {
                        isShownParametersView.toggle()
                    } label: {
                        CustomHStackInProfileUserView(image: "person.circle", text: "Personal information")
                        
                    }.background(NavigationLink("", destination: PersonalInformationView(userCollectionViewModel: userCollectionViewModel), isActive: $isShownParametersView))
                          
                    Text("BECOMING A SWART ARTIST")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .bold()
                        .padding(.top, 20)
                    
                    Button {
                        artistCollectionViewModel.isAlreadyAnArtist(documentId: authentificationViewModel.userId.id ?? "") { result in
                            if result {
                                isShownArtistTabView.toggle()
                            } else {
                                isShownBecomeAnArtistHomePageView.toggle()
                            }
                        }
                    } label: {
                        CustomHStackInProfileUserView(image: "arrow.triangle.swap", text: "Switch to artist mode")
                        
                    }.fullScreenCover(isPresented: $isShownBecomeAnArtistHomePageView, content: {
                        BecomeAnArtistHomePageView()
                    }).fullScreenCover(isPresented: $isShownArtistTabView, content: {
                        ArtistTabView()
                    })
                }.padding(.vertical, 30)
                .padding(.horizontal, 22)
                
                VStack {
       
                    Spacer()
                    
                    Button {
                        isAlertPresented = true
                    } label: {
                        LabelForLogOutButton()
                    }.fullScreenCover(isPresented: $isShownHomePage, content: {
                        HomeView()
                    })
                }.padding(.bottom, 40)
                .padding(.horizontal, 50)
                .alert(isPresented: $isAlertPresented) {
                    Alert(title: Text("Are you sure you want to log out?"),
                    message: .none,
                    primaryButton: .destructive(Text("Confirm")) {
                        authentificationViewModel.logOutUser {
                            authentificationViewModel.pastUserId.id = ""
                            isShownHomePage = true
                        }
                    },
                    secondaryButton: .cancel())
                }
            }.navigationBarHidden(true)
        }.navigationViewStyle(.stack)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUserView(userCollectionViewModel: UserCollectionViewModel())
    }
}

// MARK: - Refactoring structures

struct ModifierForImageInProfileUserView: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 80, height: 80)
            .clipShape(Circle())
    }
}

struct CustomHStackInProfileUserView: View {
    
    var image: String
    var text: String
    
    var body: some View {
        
        HStack {
            Image(systemName: image)
                .foregroundColor(.black)
                .font(.system(size: 22))
            Text(text)
                .font(.system(size: 22))
                .foregroundColor(.black)
                .padding(.horizontal, 8)
                
            Spacer()
                
            Image(systemName: "chevron.right")
                .foregroundColor(.black)
                .font(.system(size: 22))
        }
    }
}
