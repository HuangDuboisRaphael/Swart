//
//  HeadlineView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 12/11/2021.
//

import SwiftUI

// Sixth view for artist form where the future artist is asked to add a headline.
// Once confirmed, send headline to database.
struct HeadlineView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    @Binding var resetToRootView: Bool
    
    @State private var headline = ""
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State private var textExamples = TextExamples()
    
    // MARK: - Body
    
    var body: some View {

        ZStack {
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                
                Spacer(minLength: UIScreen.main.bounds.height * 2/5)
                
                TitleForArtistForm(text: "Give yourself a headline")
                  
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text("Your headline")
                                .font(.system(size: 14)).bold()
                                .padding(.vertical, 7)
                                .foregroundColor(.black)
                            
                            MultiTextFieldForHeadline(defaultExample: $textExamples.exampleForHeadline, text: $headline)
                                .frame(height: 115)
                                .background(Color.lightGrayForBackground)
                                .cornerRadius(10)
                            
                            HStack {
                                Spacer()
                                
                                Text("\(headline.count)/60")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                                    .padding(.top, 4)
                            }
                        }.padding(.vertical, 20)
                        .padding(.horizontal)
                        .padding(.bottom, keyboardHandler.keyboardHeight)
                        
                        Spacer()
                    
                        HStack {

                            Spacer()
                            
                            NavigationLink(destination: TextPresentationView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button {
                                    if headline.isEmpty {
                                        alertMessage = "Please come out with a headline before continuing."
                                        isAlertPresented = true
                                    } else {
                                        artistCollectionViewModel.addSingleFieldToArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameField: "headline", field: headline)
                                        self.isLinkActive = true
                                    }
                                } label: {
                                    NextButtonForArtistForm()
                                }.alert(isPresented: $isAlertPresented) {
                                    Alert(title: Text(alertMessage))
                                }
                            }.isDetailLink(false)
                        }.padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .padding(.bottom, keyboardHandler.keyboardHeight / 2)
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct HeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineView(resetToRootView: .constant(false))
    }
}
