//
//  SelectPlaceView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 08/01/2022.
//

import SwiftUI

// Third search view where user selects his desired place to attend the performance.
struct SelectPlaceView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @StateObject private var userCollectionViewModel = UserCollectionViewModel()
    
    @Binding var selectedArtName: String
    @Binding var selectedDepartments: [String]
    
    @State private var isShowingAlert = false
    @State private var isLinkActive = false
    @State private var isLinkAddressActive = false
    @State private var selectedPlaceNameForFilter = ""
    @State private var selectedPlaceName = ""
    @State private var fromAddressView = false
    
    private let places: [Place] = PlaceList.places
    
    // MARK: - Body
    
    var body: some View {

        ZStack {
            
            BackgroundForArtistForm()
        
            VStack {
                
               Spacer()
                
                ZStack {
                    
                    VStack {
                        
                        HStack {
                        
                            TitleForArtistForm(text: "Where do you prefer?")
            
                            Spacer()
                        }.padding(.horizontal, 12)
            
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: UIScreen.main.bounds.height / 1.6)
                            .foregroundColor(Color.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        ZStack {
                            
                            HStack {
                                Text(selectedArtName)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 19))
                                    .gradientForeground(colors: [Color(#colorLiteral(red: 0.7496727109, green: 0.1164080873, blue: 0.1838892698, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1))])
                            }
                        
                            HStack {
                                
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(systemName: "chevron.backward")
                                        .foregroundColor(.black).opacity(0.6)
                                        .font(.system(size: 19))
                                        
                                }
                                Spacer()
                                
                            }.padding(.horizontal, 32)
                        }.padding(.top, 30)
                        
                        VStack {
                            
                            ForEach(places) { place in
                                    
                                Button {
                                    selectedPlaceName = place.name
                                    
                                    if place.name == "Artist's place" {
                                        selectedPlaceNameForFilter = "Your place"
                                        isLinkActive = true
                                    } else if place.name == "Your place" {
                                        selectedPlaceNameForFilter = "Audience's place"
                                        if userCollectionViewModel.user.address == "" {
                                            isShowingAlert = true
                                        } else {
                                            isLinkActive = true
                                        }
                                    } else {
                                        selectedPlaceNameForFilter = place.name
                                        if userCollectionViewModel.user.address == "" {
                                            isShowingAlert = true
                                        } else {
                                            isLinkActive = true
                                        }
                                    }
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
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white).shadow(radius: 5, y: 3))
                                }
                            }.alert(isPresented: $isShowingAlert) {
                                Alert(
                                    title: Text("Add your address"),
                                    message: Text("To continue, you need to communicate your address to the Artist."),
                                    primaryButton: .destructive(Text("Continue")) {
                                        isLinkAddressActive = true
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                        }.background(NavigationLink("", destination: SelectDateView(selectedArtName: $selectedArtName, selectedDepartments: $selectedDepartments, selectedPlaceNameForFilter: $selectedPlaceNameForFilter, selectedPlaceName: $selectedPlaceName, fromAddressView: $fromAddressView), isActive: $isLinkActive))
                            .background(NavigationLink("", destination: EnterUserAddressView(selectedArtName: $selectedArtName, selectedDepartments: $selectedDepartments, selectedPlaceNameForFilter: $selectedPlaceNameForFilter, selectedPlaceName: $selectedPlaceName), isActive: $isLinkAddressActive))
                    }
                }.onAppear {
                    userCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "")
                }
            }.edgesIgnoringSafeArea(.bottom)
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct SelectPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPlaceView(selectedArtName: .constant(""), selectedDepartments: .constant([]))
    }
}
