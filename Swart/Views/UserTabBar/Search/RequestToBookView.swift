//
//  RequestToBookView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 03/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import ActivityIndicatorView

// Last search view where all booking information are summarized, user needs to check them and to fill as well the number of guests and send a private message to the artist.
// Once confirmed, create one user request and one artist request which are sent to the database and add requests reference in user and artist collection, then user returns to home user tab view.
struct RequestToBookView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    @StateObject private var addressViewModel = AddressViewModel()
    @StateObject private var requestArtistCollectionViewModel = RequestArtistCollectionViewModel()
    @StateObject private var requestUserCollectionViewModel = RequestUserCollectionViewModel()
    
    @ObservedObject var userCollectionViewModel: UserCollectionViewModel
    
    @Binding var selectedArtist: Artist
    @Binding var selectedDate: String
    @Binding var selectedDateForRequest: String
    @Binding var selectedPlaceName: String
    
    @State private var guest = ""
    @State private var message = ""
    @State private var isShowMain = false
    @State private var isShowMainAlert = false
    @State private var isLoading = false
    @State private var textExamples = TextExamples()
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State private var requestArtist = RequestArtist(requestId: "", requestIdUser: "", idUser: "", firstName: "", city: "", department: "", address: "", date: "", location: "", guest: "", message: "", coverPhoto: "", accepted: false)
    @State private var requestUser = RequestUser(requestId: "", headline: "", city: "", department: "", address: "", date: "", location: "", guest: "", coverPhoto: "", accepted: false)
    
    private let number = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
            
            ScrollView {
            
                VStack(alignment: .leading, spacing: 25) {
                    
                    Divider()
                    
                    HStack {
                        
                        AnimatedImage(url: URL(string: selectedArtist.artContentMedia[0]))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 125, height: 115, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
      
                        VStack(alignment: .leading, spacing: 22) {
                            
                            Text(selectedArtist.headline).bold()
                                .foregroundColor(.black).opacity(0.8)
                                .font(.system(size: 18))
                                .lineLimit(1)
                            
                            Text(addressViewModel.determineCity(address: selectedArtist.address))
                                .modifier(ModifierForTextInRequestToBookView())
                            
                            Text(addressViewModel.rewriteDepartment(department: selectedArtist.department))
                                .modifier(ModifierForTextInRequestToBookView())
                            
                        }.padding(.leading, 5)
                        
                        Spacer()
                        
                    }.padding(.horizontal, 20)
                    
                    Rectangle()
                        .frame(height: 10)
                        .foregroundColor(.gray).opacity(0.3)
                    
                    VStack(alignment: .leading, spacing: 26) {
                    
                        Text("Your experience")
                            .font(.system(size: 19)).bold()
                            .foregroundColor(.black)
                        
                        CustomVStackInRequestToBookView(title: "Date", text: selectedDate)
                        
                        CustomVStackInRequestToBookView(title: "Location", text: addressViewModel.determineLocation(selectedPlaceName: selectedPlaceName, artistPlace: selectedArtist.place))
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            HStack {
                                
                                if guest != "1" && guest != "" {
                                    Text("Guests:")
                                        .font(.system(size: 17)).bold()
                                        .foregroundColor(.black).opacity(0.9)
                                        .padding(.top, -2)
                                } else {
                                    Text("Guest:")
                                        .font(.system(size: 17)).bold()
                                        .foregroundColor(.black).opacity(0.9)
                                        .padding(.top, -2)
                                }
                            
                                Picker("", selection: $guest) {
                                    ForEach(number, id: \.self) {
                                        Text($0)
                                    }
                                }.colorMultiply(.black)
                                .padding(.leading, -8)
                            }
                        }
                    }.padding(.horizontal, 20)
                    
                    Rectangle()
                        .frame(height: 10)
                        .foregroundColor(.gray).opacity(0.3)
                    
                    VStack(alignment: .leading, spacing: 20) {
                    
                        VStack(alignment: .leading, spacing: 6) {
                        
                            Text("Message the Artist")
                                .font(.system(size: 19)).bold()
                                .foregroundColor(.black)
                            
                            Text("Share with the Artist your passion for ").font(.footnote).foregroundColor(.black) + Text(selectedArtist.art).font(.footnote).foregroundColor(.black) + Text(" or the reason why you want to discover it.").font(.footnote).foregroundColor(.black)
                        }
                        
                        MultiTextFieldForPresentation(defaultExample: $textExamples.exampleForRequestMessage, text: $message)
                                .frame(height: 130)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black.opacity(0.4), lineWidth: 1))
                    }.padding(.horizontal, 20)
                    
                    Rectangle()
                        .frame(height: 10)
                        .foregroundColor(.gray).opacity(0.3)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("By selecting the button below, I agree to the ").font(.footnote).foregroundColor(.black) + Text("Artist's House Rules and Swart's User Policy.").underline().font(.footnote).foregroundColor(.black)
                            
                        Button {
                            
                            if guest == "" {
                                alertMessage = "Please indicate the number of guests expected."
                                isAlertPresented = true
                            } else if message == "" {
                                alertMessage = "Please write a message for the Artist."
                                isAlertPresented = true
                            } else {
                                
                                isLoading = true
                    
                                requestArtist = RequestArtist(requestId: "", requestIdUser: "", idUser: authentificationViewModel.userId.id ?? "", firstName: userCollectionViewModel.user.firstName, city: addressViewModel.determineCity(address: userCollectionViewModel.user.address), department: addressViewModel.rewriteDepartment(department: selectedArtist.department), address: userCollectionViewModel.user.address, date: selectedDateForRequest, location: addressViewModel.determineLocation(selectedPlaceName: selectedPlaceName, artistPlace: selectedArtist.place), guest: guest, message: message, coverPhoto: userCollectionViewModel.user.profilePhoto, accepted: false)
                                requestUser = RequestUser(requestId: "", headline: selectedArtist.headline, city: addressViewModel.determineCity(address: selectedArtist.address), department: addressViewModel.rewriteDepartment(department: selectedArtist.department), address: selectedArtist.address, date: selectedDateForRequest, location: addressViewModel.determineLocation(selectedPlaceName: selectedPlaceName, artistPlace: selectedArtist.place), guest: guest, coverPhoto: selectedArtist.profilePhoto, accepted: false)
                                
                                requestArtistCollectionViewModel.addDocumentToRequestArtistCollection(request: requestArtist) {
                                    requestUserCollectionViewModel.addDocumentToRequestUserCollection(request: requestUser) {
                                        requestUserCollectionViewModel.addIdToRequest()
                                        requestArtistCollectionViewModel.addIdsToRequest(requestIdUser: requestUserCollectionViewModel.requestReference)
                                        artistCollectionViewModel.insertElementInExistingArrayField(documentId: selectedArtist.id, titleField: "pendingRequest", element: requestArtistCollectionViewModel.requestReference)
                                        userCollectionViewModel.insertElementInExistingArrayField(documentId: authentificationViewModel.userId.id ?? "", titleField: "pendingRequest", element: requestUserCollectionViewModel.requestReference)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            isShowMainAlert = true
                                            isLoading = false
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text("Request to book").bold()
                                .frame(maxWidth: . infinity)
                                .frame(height: 20, alignment: .center)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(.mainRed).opacity(0.8))
                        }.alert("A request has been sent to the Artist!", isPresented: $isShowMainAlert) {
                            Button("Great", role: .cancel) {
                                isShowMain = true
                            }
                        }
                    }.padding(.horizontal, 20)
                }.alert(isPresented: $isAlertPresented) {
                    Alert(title: Text(alertMessage))
                }
            }.isHidden(isLoading ? true : false)
            .fullScreenCover(isPresented: $isShowMain) {
                UserTabView()
            }.onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
            }
        }.navigationTitle("Request to book")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    BackwardChevron()
                })
            }
        }
    }
}

struct RequestToBookView_Previews: PreviewProvider {
    static var previews: some View {
        RequestToBookView(userCollectionViewModel: UserCollectionViewModel(), selectedArtist: .constant(Artist(id: "", art: "", place: "", address: "", department: "", headline: "", textPresentation: "", profilePhoto: "", presentationVideo: "", artContentMedia: [], blockedDates: [], pendingRequest: [], comingRequest: [], previousRequest: [])), selectedDate: .constant(""), selectedDateForRequest: .constant(""), selectedPlaceName: .constant(""))
    }
}

// MARK: - Refactoring structures

struct CustomVStackInRequestToBookView: View {
    
    var title: String
    var text: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            Text(title)
                .font(.system(size: 17)).bold()
                .foregroundColor(.black).opacity(0.9)
            
            Text(text)
                .foregroundColor(.black).opacity(0.4)
        }
    }
}

struct ModifierForTextInRequestToBookView: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black).opacity(0.6)
            .font(Font.system(size: 17).italic())
            .lineLimit(1)
    }
}
