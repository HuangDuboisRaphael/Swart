//
//  SwiftUIView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 27/10/2021.
//

import SwiftUI
import MapKit
import ActivityIndicatorView

// Future artist decides to manually fill his address information. After validation, upload in database his address information.
struct ConfirmAddressManually: View {
    
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
    @State private var isAlertPresented = false
    @State private var isAlertConfirmAddressPresented = false
    @State private var isLoading = false
    @State private var isLinkActive = false
    @State private var fullAddress = ""
    @State private var isShowLinkAlert = false
    
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
                                    .textContentType(.countryName)
                                    .autocapitalization(.words)
                                    .foregroundColor(.black)
                        
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
                
                    NavigationLink(destination: ProfilePhotoView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                
                        Button {
                        
                            fullAddress = "\(subThoroughfare)" + " \(thoroughfare)" + ", \(postalCode)" + " \(locality)" + ", \(country)"
                        
                            if !isAddressIncomplete() {
                                addressViewModel.convertAddressIntoMapLocation(address: fullAddress) {
                                isLoading = true
                                    if addressViewModel.convertedCoordinatesAddress != nil {
                                        artistCollectionViewModel.addAddressInformationToDatabase(documentId: authentificationViewModel.userId.id ?? "", address: fullAddress, department: addressViewModel.determineDepartmentToSaveInDatabase(postalCode: postalCode)) {
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
                            artistCollectionViewModel.addAddressInformationToDatabase(documentId: authentificationViewModel.userId.id ?? "", address: fullAddress, department: addressViewModel.determineDepartmentToSaveInDatabase(postalCode: postalCode)) {
                                isShowLinkAlert = true
                            }
                        },
                        secondaryButton: .cancel())
                    }
                }.padding(.vertical, 3)
            }.isHidden(isLoading ? true : false)
        }.padding(.horizontal, 5)
        .navigationBarTitle(Text("Enter your address"), displayMode: .inline)
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

struct ConfirmAddressManually_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmAddressManually(addressViewModel: AddressViewModel(), resetToRootView: .constant(false))
    }
}
