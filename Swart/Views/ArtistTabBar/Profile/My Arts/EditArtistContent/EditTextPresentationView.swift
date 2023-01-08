//
//  EditTextPresentationView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 18/12/2021.
//

import SwiftUI
import ActivityIndicatorView

// To edit current artist's text presentation, once confirmed would replace old text presentation by the new one in the database.
struct EditTextPresentationView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    
    @State private var text = ""
    @State private var textCopy = ""
    @State private var hasEdited = false
    @State private var isLoading = false
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // MARK: - Body
    
    var body: some View {
        
       ZStack {
           
           Color.white
               .ignoresSafeArea()
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
        
            VStack {
                
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        BackwardChevron()
                            .padding()
                    })
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 25) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Presentation")
                            .font(.title).bold()
                            .foregroundColor(.black)
                        
                        Text("Feel free to edit your current presentation")
                            .font(.footnote)
                            .foregroundColor(.black)
                    }
                        
                    MultiTextFieldForPresentation(defaultExample: $artistCollectionViewModel.artist.textPresentation, text: $text)
                            .frame(height: 220)
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
                }.padding(.horizontal, 20)
                
                Spacer()
                
                HStack {
                    Spacer()
                
                    ZStack {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 85, height: 45)
                            .foregroundColor(.mainRed)
                            .opacity(hasEdited ? 1 : 0.2)
                        
                        Button {
                            isLoading = true
                            artistCollectionViewModel.addSingleFieldToArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameField: "textPresentation", field: text) {
                                artistCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        self.presentationMode.wrappedValue.dismiss()
                                        isLoading = false
                                    }
                                }
                            }
                        } label: {
                            Text("Save")
                                .font(.system(size: 18)).bold()
                                .foregroundColor(.white)
                        }.disabled(hasEdited ? false : true)
                    }.padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }.onAppear(perform: {
                    textCopy = text
                })
                .onReceive(timer) { _ in
                    if textCopy != text && !text.isEmpty {
                        hasEdited = true
                    }
                    if text.isEmpty {
                        hasEdited = false
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }.isHidden(isLoading ? true : false)
        }
    }
}

struct EditTextPresentationView_Previews: PreviewProvider {
    static var previews: some View {
        EditTextPresentationView(artistCollectionViewModel: ArtistCollectionViewModel())
    }
}
