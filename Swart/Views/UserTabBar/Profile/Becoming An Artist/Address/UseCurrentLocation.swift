//
//  ConfirmAddressView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 26/10/2021.
//

import SwiftUI
import ActivityIndicatorView

// Future artist accepts to be geolocated and all his address information are retrieved in that view, he only needs to confirm or edit them if needed.
// Before going to the next view, upload in database artist address information.
struct UseCurrentLocation: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @ObservedObject var addressViewModel: AddressViewModel
    
    @Binding var resetToRootView: Bool
    
    @State private var country = ""
    @State private var locality = ""
    @State private var thoroughfare = ""
    @State private var postalCode = ""
    @State private var subThoroughfare = ""
    @State private var fullAddress = ""
    @State private var isLinkActive = false
    @State private var isLoading = true
    @State private var isAlertPresented = false
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
            
            ScrollView {
            
                VStack(spacing: 20) {
                    
                    Group {
                        VStack {
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Street Number")
                                                
                                CustomTextfieldForProfile(bindingText: $subThoroughfare, text: subThoroughfare, textFromDb: addressViewModel.address.subThoroughfare)
                                    .keyboardType(.numberPad)
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Street")
                                                
                                CustomTextfieldForProfile(bindingText: $thoroughfare, text: thoroughfare, textFromDb: addressViewModel.address.thoroughfare)
                                    .textContentType(.addressCity)
                                    .autocapitalization(.words)
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "City")
                                                
                                CustomTextfieldForProfile(bindingText: $locality, text: locality, textFromDb: addressViewModel.address.locality)
                                    .textContentType(.addressCity)
                                    .autocapitalization(.words)
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Postal Code")
                                                
                                CustomTextfieldForProfile(bindingText: $postalCode, text: postalCode, textFromDb: addressViewModel.address.postalCode)
                                    .keyboardType(.numberPad)
                                    .textContentType(.postalCode)
                                    .autocapitalization(.words)
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Country")
                                                
                                CustomTextfieldForProfile(bindingText: $country, text: country, textFromDb: addressViewModel.address.country)
                                    .textContentType(.countryName)
                                    .autocapitalization(.words)
                            }.padding()
                            
                            Divider()
                        }
                        TextForAddressPolicy()
                    }
                }
            
                VStack {
                    NavigationLink(destination: ProfilePhotoView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                        Button {
                            
                            fullAddress = "\(addressViewModel.selectAddressElement(modifyElement: subThoroughfare, currentElement: addressViewModel.address.subThoroughfare))" + " \(addressViewModel.selectAddressElement(modifyElement: thoroughfare, currentElement: addressViewModel.address.thoroughfare))" + ", \(addressViewModel.selectAddressElement(modifyElement: postalCode, currentElement: addressViewModel.address.postalCode))" + " \(addressViewModel.selectAddressElement(modifyElement: locality, currentElement: addressViewModel.address.locality))" + ", \(addressViewModel.selectAddressElement(modifyElement: country, currentElement: addressViewModel.address.country))"
                            
                            artistCollectionViewModel.addAddressInformationToDatabase(documentId: authentificationViewModel.userId.id ?? "", address: fullAddress, department: addressViewModel.determineDepartmentToSaveInDatabase(postalCode: addressViewModel.selectAddressElement(modifyElement: postalCode, currentElement: addressViewModel.address.postalCode))) {
                                isLinkActive = true
                            }
                        } label: {
                            CustomTextForButton(text: "Looks good")
                                .padding()
                        }
                    }.alert(isPresented: $isAlertPresented) {
                        Alert(title: Text("Please fill all required information."))
                    }
                }.padding(.vertical, 8)
            }.isHidden(isLoading ? true : false)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isLoading = false
                }
            }
        }.padding(.horizontal, 5)
        .navigationBarTitle(Text("Confirm your address"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                BackwardChevron()
            }))
    }
}

struct ConfirmAddressView_Previews: PreviewProvider {
    static var previews: some View {
        UseCurrentLocation(addressViewModel: AddressViewModel(), resetToRootView: .constant(false))
    }
}
