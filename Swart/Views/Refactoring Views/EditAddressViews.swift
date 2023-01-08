//
//  EditAddressViews.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 14/03/2022.
//

import SwiftUI

// Refactoring structures using in edit address views.
struct DisplayAddressInformation: View {
    
    @Binding var subThoroughfare: String
    @Binding var subThoroughfareFromDb: String
    @Binding var thoroughfare: String
    @Binding var thoroughfareFromDb: String
    @Binding var locality: String
    @Binding var localityFromDb: String
    @Binding var postalCode: String
    @Binding var postalCodeFromDb: String
    @Binding var country: String
    @Binding var countryFromDb: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            Text("Address")
                    .font(.title).bold()
                    .foregroundColor(.black)
                 
            Text("Edit your address information if needed")
                    .font(.footnote)
                    .foregroundColor(.black)
        }.padding(.horizontal, 20)
        
        Group {
            VStack {
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "Street Number")
                                    
                    CustomTextfieldForProfile(bindingText: $subThoroughfare, text: subThoroughfare, textFromDb: subThoroughfareFromDb)
                        .keyboardType(.numberPad)
                }.padding()
                            
                Divider()
                        
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "Street")
                    
                    CustomTextfieldForProfile(bindingText: $thoroughfare, text: thoroughfare, textFromDb: thoroughfareFromDb)
                        .textContentType(.addressCity)
                        .autocapitalization(.words)
                }.padding()
                            
                Divider()
                        
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "City")
                    
                    CustomTextfieldForProfile(bindingText: $locality, text: locality, textFromDb: localityFromDb)
                        .textContentType(.addressCity)
                        .autocapitalization(.words)
                }.padding()
                            
                Divider()
                        
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "Postal Code")
                    
                    CustomTextfieldForProfile(bindingText: $postalCode, text: postalCode, textFromDb: postalCodeFromDb)
                        .keyboardType(.numberPad)
                        .textContentType(.postalCode)
                        .autocapitalization(.words)
                }.padding()
                            
                Divider()
                        
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "Country")
                                    
                    CustomTextfieldForProfile(bindingText: $country, text: country, textFromDb: countryFromDb)
                        .textContentType(.countryName)
                        .autocapitalization(.words)
                }.padding()
                
                Divider()
                
            }.padding(.horizontal, 6)
                        
            Text("We'll only share your address with artists who are booked as outlined in our privacy policy.")
                .fontWeight(.semibold)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
        }
    }
}
