//
//  AddressView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 24/10/2021.
//

import SwiftUI
import MapKit
import CoreLocation

// Fourth view for artist form where the future artist is asked to communicate his address. If geolocation accepted, display a map with future artist's location pin.
struct AddressView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var userCollectionViewModel = UserCollectionViewModel()
    @StateObject private var addressViewModel = AddressViewModel()
        
    @Binding var resetToRootView: Bool
    
    @State private var convertedRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                                            span: AddressViewModel.span)
    @State private var convertedCoordinatesAddress: CLLocationCoordinate2D?
    @State private var isParentViewLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State private var isLinkActive = false
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                
                VStack(alignment: .leading, spacing: -20) {
                    
                    TitleForArtistForm(text: "Where's your place located?")
                        .padding(.vertical)
                    
                    CaptionForArtistForm(text: "We'll only share your address with guests who are booked as outlined in our privacy policy.")
                }
                
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                
                    VStack {
                        
                        ZStack {
                
                            Map(coordinateRegion: $addressViewModel.region, showsUserLocation: true)
                                .ignoresSafeArea()
                                .accentColor(.mainRed)
                                .onAppear {
                                    addressViewModel.checkIfLocationServicesIsEnabled()
                                }
                            
                            VStack(alignment: .leading) {
                            
                                Button {
                                    isLinkActive = true
                                } label: {
                                    HStack(spacing: 15) {
                                        Image(systemName: "location.fill")
                                            .foregroundColor(.black)
                                            
                                        Text("Enter your address")
                                            .foregroundColor(.black)
                                            
                                        Spacer()
                                            
                                    }.padding(.horizontal, 25)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 50)
                                            .foregroundColor(Color.white)
                                            .padding(.horizontal, 15)
                                            .frame(maxWidth: .infinity))
                                }.background(NavigationLink("", destination: EnterAddressView(addressViewModel: addressViewModel, resetToRootView: $resetToRootView), isActive: $isLinkActive))
                                
                                Spacer()
        
                            }.padding()
                        }
                    }.alert(isPresented: $addressViewModel.permissionDenied, content: {
                        Alert(title: Text("Permission Denied"), message: Text("Please enable permission in App Settings"), dismissButton: .default(Text("Go to Settings"), action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }))
                    })
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(resetToRootView: .constant(false))
    }
}
