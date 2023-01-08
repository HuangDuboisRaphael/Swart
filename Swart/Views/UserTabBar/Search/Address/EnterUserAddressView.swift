//
//  EnterUserAddressView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 18/02/2022.
//

import SwiftUI

// If user chooses his place for the perfomance, he needs to communicate his address manually and with the geolocation feature.
struct EnterUserAddressView: View {
    
    // MARK: - Properties
    
    @StateObject private var addressViewModel = AddressViewModel()
    
    @Binding var selectedArtName: String
    @Binding var selectedDepartments: [String]
    @Binding var selectedPlaceNameForFilter: String
    @Binding var selectedPlaceName: String
    
    @State private var address = Address(country: "", locality: "", thoroughfare: "", postalCode: "", subThoroughfare: "")
    @State private var isLinkActive = false
    @State private var isLinkActiveManually = false
    @State private var street = ""
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
                
            VStack(spacing: 30) {
              
                NavigationLink(destination: UseUserCurrentLocationView(addressViewModel: addressViewModel, selectedArtName: $selectedArtName, selectedDepartments: $selectedDepartments, selectedPlaceNameForFilter: $selectedPlaceNameForFilter, selectedPlaceName: $selectedPlaceName), isActive: $isLinkActive) {
                    Button {
                        isLinkActive = true
                    } label: {
                        LabelAddressView(image: "location.fill", text: "Use my current location")
                    }
                }
                    
                NavigationLink(destination: ConfirmUserAddressManuallyView(addressViewModel: addressViewModel, selectedArtName: $selectedArtName, selectedDepartments: $selectedDepartments, selectedPlaceNameForFilter: $selectedPlaceNameForFilter, selectedPlaceName: $selectedPlaceName), isActive: $isLinkActiveManually) {
                    Button {
                        self.isLinkActiveManually = true
                    } label: {
                        LabelAddressView(image: "keyboard", text: "Enter address manually")
                    }
                }.onAppear {
                    addressViewModel.checkIfLocationServicesIsEnabled()
                }.alert(isPresented: $addressViewModel.permissionDenied, content: {
                    Alert(title: Text("Permission Denied"), message: Text("Please enable permission in App Settings"), dismissButton: .default(Text("Go to Settings"), action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }))
                })
            }.navigationBarBackButtonHidden(true)
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
            }
        .navigationBarTitle(Text("Enter your address"), displayMode: .inline)
        }
    }
}

struct EnterUserAddressView_Previews: PreviewProvider {
    static var previews: some View {
        EnterUserAddressView(selectedArtName: .constant(""), selectedDepartments: .constant([]), selectedPlaceNameForFilter: .constant(""), selectedPlaceName: .constant(""))
    }
}
