//
//  ConfirmAddressView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 25/10/2021.
//

import SwiftUI
import MapKit

// In this view, future artist decides between using geolocated address information or manually enters its.
struct EnterAddressView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var addressViewModel: AddressViewModel

    @Binding var resetToRootView: Bool
    
    @State private var isLinkActive = false
    @State private var isLinkActiveManually = false
    @State private var street = ""
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
                
            VStack(spacing: 30) {
              
                NavigationLink(destination: UseCurrentLocation(addressViewModel: addressViewModel, resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                    Button {
                        isLinkActive = true
                    } label: {
                        LabelAddressView(image: "location.fill", text: "Use my current location")
                    }
                }
                    
                NavigationLink(destination: ConfirmAddressManually(addressViewModel: addressViewModel, resetToRootView: $resetToRootView), isActive: $isLinkActiveManually) {
                    Button {
                        self.isLinkActiveManually = true
                    } label: {
                        LabelAddressView(image: "keyboard", text: "Enter address manually")
                    }
                }.isDetailLink(false)
            }.onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
            }
            .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text("Enter your address"), displayMode: .inline)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                BackwardChevron()
            }))
        }
    }
}
