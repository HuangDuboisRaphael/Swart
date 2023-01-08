//
//  ProfileArtistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/12/2021.
//

import SwiftUI

// Third artist tab where artist can edit his art information, navigate to the user tab view or to log out and return to HomeView.
struct ProfileArtistView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    
    @State private var isShownMyArtView = false
    @State private var isShownUserTabView = false
    @State private var isShownHomePage = false
    @State private var isAlertPresented = false
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.white
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 30) {
            
                    Text("ACCOUNT")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .bold()
                    
                    Button {
                        isShownMyArtView = true
                    } label: {

                        CustomHStackInProfileUserView(image: "paintbrush.pointed", text: "My Art")
                        
                    }.fullScreenCover(isPresented: $isShownMyArtView, content: {
                        MyArtsView(artistCollectionViewModel: artistCollectionViewModel)
                    })
                          
                    Text("DISCOVER A MULTITUDE OF ARTISTS")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .bold()
                        .padding(.top, 20)
                    
                    Button {
                        isShownUserTabView = true
                    } label: {
                        CustomHStackInProfileUserView(image: "arrow.triangle.swap", text: "Switch to user mode")
                    }.fullScreenCover(isPresented: $isShownUserTabView, content: {
                        UserTabView()
                    })
                }.padding(.top, -106)
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
                .navigationTitle("Profile")
            }
        }.navigationViewStyle(.stack)
    }
}

struct ProfileArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileArtistView(artistCollectionViewModel: ArtistCollectionViewModel())
    }
}
