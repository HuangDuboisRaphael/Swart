//
//  UseUserCurrentLocationView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 18/02/2022.
//

import SwiftUI

// User accepts to be geolocated and all his address information are retrieved in that view, he only needs to confirm or edit them if needed.
// Before going to the next view, upload in database user address information.
struct UseUserCurrentLocationView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var userCollectionViewModel = UserCollectionViewModel()
    
    @ObservedObject var addressViewModel: AddressViewModel
    
    @Binding var selectedArtName: String
    @Binding var selectedDepartments: [String]
    @Binding var selectedPlaceNameForFilter: String
    @Binding var selectedPlaceName: String
    
    @State private var country = ""
    @State private var locality = ""
    @State private var thoroughfare = ""
    @State private var postalCode = ""
    @State private var subThoroughfare = ""
    @State private var fullAddress = ""
    @State private var isLinkActive = false
    @State private var isLoading = true
    @State private var isShowAlert = false
    @State private var fromAddressView = true
    
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
                    NavigationLink(destination: SelectDateView(selectedArtName: $selectedArtName, selectedDepartments: $selectedDepartments, selectedPlaceNameForFilter: $selectedPlaceNameForFilter, selectedPlaceName: $selectedPlaceName, fromAddressView: $fromAddressView), isActive: $isLinkActive) {
                        Button {
                            isLoading = true
                            fullAddress = "\(addressViewModel.selectAddressElement(modifyElement: subThoroughfare, currentElement: addressViewModel.address.subThoroughfare))" + " \(addressViewModel.selectAddressElement(modifyElement: thoroughfare, currentElement: addressViewModel.address.thoroughfare))" + ", \(addressViewModel.selectAddressElement(modifyElement: postalCode, currentElement: addressViewModel.address.postalCode))" + " \(addressViewModel.selectAddressElement(modifyElement: locality, currentElement: addressViewModel.address.locality))" + ", \(addressViewModel.selectAddressElement(modifyElement: country, currentElement: addressViewModel.address.country))"
                            
                            userCollectionViewModel.addAddressInformationToDatabase(documentId: authentificationViewModel.userId.id ?? "", documentAddress: fullAddress, documentDepartment: addressViewModel.determineDepartmentToSaveInDatabase(postalCode: addressViewModel.selectAddressElement(modifyElement: postalCode, currentElement: addressViewModel.address.postalCode))) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    isShowAlert = true
                                    isLoading = false
                                }
                            }
                        } label: {
                            CustomTextForButton(text: "Looks good")
                                .padding()
                        }
                    }.alert("Address successfully added!", isPresented: $isShowAlert) {
                        Button("OK", role: .cancel) {
                            isLinkActive = true
                        }
                    }
                }.padding(.vertical, 8)
            }.isHidden(isLoading ? true : false)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
        }.padding(.horizontal, 5)
        .navigationTitle("Confirm your address")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                BackwardChevron()
            }))
    }
}

struct UseUserCurrentLocationView_Previews: PreviewProvider {
    static var previews: some View {
        UseUserCurrentLocationView(addressViewModel: AddressViewModel(), selectedArtName: .constant(""), selectedDepartments: .constant([]), selectedPlaceNameForFilter: .constant(""), selectedPlaceName: .constant(""))
    }
}
