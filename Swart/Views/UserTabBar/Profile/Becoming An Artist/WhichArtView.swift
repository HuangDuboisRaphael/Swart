//
//  WhichArtistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 03/10/2021.
//

import SwiftUI

// Second view for artist form where the future artist is asked to select the art he wants to perform, once confirmed, would create a new document in artist collection in firebase with the first information submitted.
struct WhichArtView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @Binding var resetToRootView: Bool
    
    @State private var selectedArt: Art?
    @State private var selectedArtName = ""
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    
    private let arts: [Art] = ArtList.arts
    
    // MARK: - Body
    
    var body: some View {

        ZStack {
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                HStack {
                    Button {
                        artistCollectionViewModel.removeUnfinishedArtistFromDatabase(documentId: authentificationViewModel.userId.id ?? "")
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing: -12) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                                .opacity(0.7)
                                .padding()
                            
                            Text("Back")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    
                    DismissButtonForArtistForm(isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                    
                }.padding(.horizontal, 10)
                    
                TitleForArtistForm(text: "What type of art do you want to perform?")
                                            
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                    
                    VStack {
                        List(arts) { art in
                            Button {
                                selectedArt = art
                                selectedArtName = art.name
                            } label: {
                                HStack {
                                    Text(art.name)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                        
                                    Spacer()
                            
                                    Image(art.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 60)
                                        .cornerRadius(4)
                                    }
                                }.listRowBackground(selectedArt == art ? Color.selectedOrange : Color.lightGrayForBackground.opacity(0.6))
                        }
                
                        HStack {

                            Spacer()
                            
                            NavigationLink(destination: WhereToPerformView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button {
                                    if selectedArtName == "" {
                                        alertMessage = "Please select an art before going to the next step."
                                        isAlertPresented = true
                                    } else {
                                        artistCollectionViewModel.setArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameDocument: "id", document: authentificationViewModel.userId.id ?? "") {
                                            artistCollectionViewModel.addSingleFieldToArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameField: "art", field: selectedArtName) {
                                                artistCollectionViewModel.addEmptyDataToArtistCollection(documentId: authentificationViewModel.userId.id ?? "")
                                                self.isLinkActive = true
                                            }
                                        }
                                    }
                                    
                                } label: {
                                    NextButtonForArtistForm()
                                }.alert(isPresented: $isAlertPresented) {
                                    Alert(title: Text(alertMessage))
                                }
                            }.isDetailLink(false)
                        }.padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct WhichArtistView_Previews: PreviewProvider {
    static var previews: some View {
        WhichArtView(resetToRootView: .constant(false))
    }
}
