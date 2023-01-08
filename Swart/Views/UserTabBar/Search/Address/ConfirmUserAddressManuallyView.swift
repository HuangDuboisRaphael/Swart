//
//  ConfirmUserAddressManually.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 18/02/2022.
//

import SwiftUI

// User decides to manually fill his address information. After validation, upload in database user address information.
struct ConfirmUserAddressManuallyView: View {
    
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
    @State private var isAlertPresented = false
    @State private var isAlertConfirmAddressPresented = false
    @State private var isShowLinkAlert = false
    @State private var isLoading = false
    @State private var isLinkActive = false
    @State private var fullAddress = ""
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
                                                
                                TextField("", text: $subThoroughfare)
                                    .keyboardType(.numberPad)
                                    .foregroundColor(.black)
                                
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Street")
                                
                                TextField("", text: $thoroughfare)
                                    .foregroundColor(.black)
                                    .autocapitalization(.words)
                                    .disableAutocorrection(true)
                                                
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "City")
                                
                                TextField("", text: $locality)
                                    .foregroundColor(.black)
                                    .autocapitalization(.words)
                                    .disableAutocorrection(true)
                                            
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Postal Code")
                                
                                TextField("", text: $postalCode)
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                                    .textContentType(.postalCode)
                                                
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Country")
                                                
                                TextField("", text: $country)
                                    .foregroundColor(.black)
                                    .textContentType(.countryName)
                                    .autocapitalization(.words)
                        
                            }.padding()
                            
                            Divider()
                        }
                                    
                        TextForAddressPolicy()
                    }
                }.alert(isPresented: $isAlertPresented) {
                    Alert(title: Text("Please fill all required information."))
                }
                    
                VStack {
                        
                    Spacer()
                
                    NavigationLink(destination: SelectDateView(selectedArtName: $selectedArtName, selectedDepartments: $selectedDepartments, selectedPlaceNameForFilter: $selectedPlaceNameForFilter, selectedPlaceName: $selectedPlaceName, fromAddressView: $fromAddressView), isActive: $isLinkActive) {
                
                        Button {
                            
                            fullAddress = "\(subThoroughfare)" + " \(thoroughfare)" + ", \(postalCode)" + " \(locality)" + ", \(country)"
                        
                            if !isAddressIncomplete() {
                                isLoading = true
                                addressViewModel.convertAddressIntoMapLocation(address: fullAddress) {
                                    if addressViewModel.convertedCoordinatesAddress != nil {
                                        userCollectionViewModel.addAddressInformationToDatabase(documentId: authentificationViewModel.userId.id ?? "", documentAddress: fullAddress, documentDepartment: addressViewModel.determineDepartmentToSaveInDatabase(postalCode: postalCode)) {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                isShowLinkAlert = true
                                                isLoading = false
                                            }
                                        }
                                    } else {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            isAlertConfirmAddressPresented = true
                                            isLoading = false
                                        }
                                    }
                                }
                            }
                        } label: {
                            CustomTextForButton(text: "Looks good")
                                .padding()
                            
                        }.alert("Address successfully added!", isPresented: $isShowLinkAlert) {
                            Button("OK", role: .cancel) {
                                isLinkActive = true
                            }
                        }
                    }
                    .alert(isPresented: $isAlertConfirmAddressPresented) {
                        Alert(title: Text("Those information don't seem to match a proper location, are you sure to confirm?"),
                        message: .none,
                        primaryButton: .destructive(Text("Confirm")) {
                            userCollectionViewModel.addAddressInformationToDatabase(documentId: authentificationViewModel.userId.id ?? "", documentAddress: fullAddress, documentDepartment: addressViewModel.determineDepartmentToSaveInDatabase(postalCode: postalCode)) {
                                isShowLinkAlert = true
                            }
                        },
                        secondaryButton: .cancel())
                    }
                }.padding(.vertical, 8)
            }.isHidden(isLoading ? true : false)
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
    
    // MARK: - Method
    
    private func isAddressIncomplete() -> Bool {
        let addressArray = [subThoroughfare, thoroughfare, postalCode, locality, country]
        
        for element in addressArray where element == "" {
            isAlertPresented = true
            return true
        }
        return false
    }
}

struct ConfirmUserAddressManually_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmUserAddressManuallyView(addressViewModel: AddressViewModel(), selectedArtName: .constant(""), selectedDepartments: .constant([]), selectedPlaceNameForFilter: .constant(""), selectedPlaceName: .constant(""))
    }
}
