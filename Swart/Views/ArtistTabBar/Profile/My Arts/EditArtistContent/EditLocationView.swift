//
//  EditLocationView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 18/12/2021.
//

import SwiftUI
import ActivityIndicatorView

// To edit current artist's address, once confirmed would replace old address by the new one in the database.
struct EditLocationView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var addressViewModel = AddressViewModel()
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    
    @State private var country = ""
    @State private var countryFromDb = ""
    @State private var locality = ""
    @State private var localityFromDb = ""
    @State private var thoroughfare = ""
    @State private var thoroughfareFromDb = ""
    @State private var postalCode = ""
    @State private var postalCodeFromDb = ""
    @State private var subThoroughfare = ""
    @State private var subThoroughfareFromDb = ""
    @State private var isLoading = false
    @State private var hasEdited = false
    @State private var isAlertConfirmAddressPresented = false
    @State private var fullAddress = ""
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
             
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
         
            VStack(alignment: .leading) {
                 
                HStack {
                 
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        BackwardChevron()
                            .padding()
                    })
                     
                    Spacer()
                }
                
                ScrollView {
                
                    VStack(alignment: .leading, spacing: 25) {
                     
                        DisplayAddressInformation(subThoroughfare: $subThoroughfare, subThoroughfareFromDb: $subThoroughfareFromDb, thoroughfare: $thoroughfare, thoroughfareFromDb: $thoroughfareFromDb, locality: $locality, localityFromDb: $localityFromDb, postalCode: $postalCode, postalCodeFromDb: $postalCodeFromDb, country: $country, countryFromDb: $countryFromDb)
                        
                        HStack {
                            
                            Spacer()
                        
                            ZStack {
                            
                                RoundedRectangle(cornerRadius: 2)
                                    .frame(width: 85, height: 45)
                                    .foregroundColor(.mainRed)
                                    .opacity(hasEdited ? 1 : 0.2)
                                
                                Button {
                                    isLoading = true
                                    
                                    fullAddress = "\(selectAddressElement(modifyElement: subThoroughfare, currentElement: subThoroughfareFromDb))" + " \(selectAddressElement(modifyElement: thoroughfare, currentElement: thoroughfareFromDb))" + ", \(selectAddressElement(modifyElement: postalCode, currentElement: postalCodeFromDb))" + " \(selectAddressElement(modifyElement: locality, currentElement: localityFromDb))" + ", \(selectAddressElement(modifyElement: country, currentElement: countryFromDb))"
                                
                                    addressViewModel.convertAddressIntoMapLocation(address: fullAddress) {
                                        if addressViewModel.convertedCoordinatesAddress != nil {
                                            artistCollectionViewModel.addAddressInformationToDatabase(documentId: authentificationViewModel.userId.id ?? "", address: fullAddress, department: addressViewModel.determineDepartmentToSaveInDatabase(postalCode: selectAddressElement(modifyElement: postalCode, currentElement: postalCodeFromDb))) {
                                                artistCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                        self.presentationMode.wrappedValue.dismiss()
                                                        isLoading = false
                                                    }
                                                }
                                            }
                                        } else {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                isLoading = false
                                                isAlertConfirmAddressPresented = true
                                            }
                                        }
                                    }
                                } label: {
                                    Text("Save")
                                        .font(.system(size: 18)).bold()
                                        .foregroundColor(.white)
                                }.disabled(hasEdited ? false : true)
                                .alert(isPresented: $isAlertConfirmAddressPresented) {
                                    Alert(title: Text("Those information don't seem to match a proper location, are you sure to confirm?"),
                                    message: .none,
                                    primaryButton: .destructive(Text("Confirm")) {
                                        isLoading = true
                                        artistCollectionViewModel.addAddressInformationToDatabase(documentId: authentificationViewModel.userId.id ?? "", address: fullAddress, department: addressViewModel.determineDepartmentToSaveInDatabase(postalCode: selectAddressElement(modifyElement: postalCode, currentElement: postalCodeFromDb))) {
                                            artistCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                    self.presentationMode.wrappedValue.dismiss()
                                                    isLoading = false
                                                }
                                            }
                                        }
                                    },
                                    secondaryButton: .cancel())
                                }
                            }.padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        }
                    }
                }.isHidden(isLoading ? true : false)
            }.onAppear {
                addressViewModel.retrieveAllAddressElements(address: artistCollectionViewModel.artist.address) { subThoroughfare in
                    subThoroughfareFromDb = subThoroughfare
                } thoroughfare: { thoroughfare in
                    thoroughfareFromDb = thoroughfare
                } locality: { locality in
                    localityFromDb = locality
                } postalCode: { postalCode in
                    postalCodeFromDb = postalCode
                } country: { country in
                    countryFromDb = country
                }
            }.onReceive(timer) { _ in
                let addressArray = [subThoroughfare, thoroughfare, postalCode, locality, country]
                
                let results = addressArray.filter { element in element != "" }
                if results.count > 0 {
                    hasEdited = true
                } else {
                    hasEdited = false
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Method
    
    private func selectAddressElement(modifyElement: String, currentElement: String) -> String {
        if modifyElement == "" {
            return currentElement
        }
        return modifyElement
    }
}

struct EditLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EditLocationView(artistCollectionViewModel: ArtistCollectionViewModel())
    }
}
