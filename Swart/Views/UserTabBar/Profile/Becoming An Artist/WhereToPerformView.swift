//
//  WhereToView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 09/10/2021.
//

import SwiftUI

// Third view for artist form where the future artist is asked to select the location he wants to perform his art, this information will be after saved in his assigned document.
struct WhereToPerformView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @Binding var resetToRootView: Bool
    
    @State private var selectedPlaceName = ""
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    
    private let places: [Place] = PlaceListArtistForm.places
    
    // MARK: - Body
    
    var body: some View {

        ZStack {
            
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                
              Spacer()
            }
                
            VStack {
                
                Spacer()
                
                HStack {
                
                    TitleForArtistForm(text: "Where do you intend to realize your art?")
                        .padding(.top, -30)
                    
                    Spacer()
                }
            
                ZStack {
                            
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: UIScreen.main.bounds.height / 1.9)
                        
                    VStack {
                        
                        VStack(spacing: -10) {
                        
                            ForEach(places) { place in
                    
                                Button {
                                    selectedPlaceName = place.name
                                } label: {
                        
                                    HStack {
                                                
                                        Image(place.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 28, height: 28)
                                            .padding(.bottom, 10)
                                                            
                                        Text(place.name)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .font(.system(size: 19))
                                            .padding(.horizontal, 10)
                                            
                                        Spacer()
                                                            
                                    }.padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(selectedPlaceName == place.name ? Color.selectedOrange : Color.white))
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white).shadow(radius: 5, y: 3))
                                }
                            }.padding()
                        }.padding(.top, -12)
                    }.padding(.horizontal, 20)
                }
            }.edgesIgnoringSafeArea(.bottom)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                        
                    NavigationLink(destination: AddressView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                        Button(action: {
                            if selectedPlaceName == "" {
                                alertMessage = "Please select a proposition before going to the next step."
                                isAlertPresented = true
                            } else {
                                artistCollectionViewModel.addSingleFieldToArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameField: "place", field: selectedPlaceName) {
                                    self.isLinkActive = true
                                }
                            }
                        }, label: {
                            NextButtonForArtistForm()
                        }).alert(isPresented: $isAlertPresented) {
                            Alert(title: Text(alertMessage))
                        }
                    }.isDetailLink(false)
                }
            }.padding(.horizontal, 20)
            .padding(.bottom, 5)
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct WhereToPerformView_Previews: PreviewProvider {
    static var previews: some View {
        WhereToPerformView(resetToRootView: .constant(false))
    }
}
