//
//  TextPresentationView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 11/10/2021.
//

import SwiftUI

// Seventh view for artist form where the future artist is asked to add a text presentation.
// Once confirmed, send text presentation to database.
struct TextPresentationView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    @Binding var resetToRootView: Bool
    
    @State private var text = ""
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
                
                Spacer(minLength: UIScreen.main.bounds.height * 2/7)
                
                VStack(alignment: .leading, spacing: -20) {
                    
                    TitleForArtistForm(text: "Let us know who you are")
                    
                    CaptionForArtistForm(text: "Introduce yourself and your artistic prestation in few sentences.")
                }
                
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                    
                    VStack {
                       
                        VStack(alignment: .leading, spacing: 4) {
                                
                            Text("Your description")
                                .font(.system(size: 14)).bold()
                                .padding(.vertical, 7)
                                .foregroundColor(.black)
                                
                            MultiTextFieldForPresentation(defaultExample: $textExamples.exampleForTextPresentation, text: $text)
                                .frame(height: 250)
                                .background(Color.lightGrayForBackground)
                                .cornerRadius(10)
                                
                            HStack {
                                Spacer()
                                
                                Text("\(text.count)/550")
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
                            
                            NavigationLink(destination: VideoPresentationView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button {
                                    if text.isEmpty {
                                        alertMessage = "Please write a presentation for your future audience."
                                        isAlertPresented = true
                                    } else {
                                        artistCollectionViewModel.addSingleFieldToArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameField: "textPresentation", field: text)
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
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct TextPresentationView_Previews: PreviewProvider {
    static var previews: some View {
        TextPresentationView(resetToRootView: .constant(false))
    }
}
