//
//  DetailExperienceArtistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 09/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import ActivityIndicatorView

// To preview the artist selected request and all the booking information related to it.
// In addition, the artist can accept or decline the pending requests received.
struct DetailExperienceArtistView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var userCollectionViewModel = UserCollectionViewModel()
    @StateObject private var requestUserCollectionViewModel = RequestUserCollectionViewModel()
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    @ObservedObject var requestArtistCollectionViewModel: RequestArtistCollectionViewModel
    
    @Binding var request: RequestArtist
    @Binding var requestType: RequestType
    @Binding var convertedDate: String
    
    @State private var isLoading = false
    @State private var showMainArtist = false
    @State private var isShowingAlert = false
    @State private var message = ""
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
        
            VStack {
                
                VStack(spacing: 10) {
                
                    HStack {
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.black).opacity(0.6)
                                .font(.system(size: 19))
                        }
                        Spacer()
                        
                    }.padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.top, 8)
                }
                
                ScrollView {
                
                    VStack(spacing: 25) {
                        
                        VStack(spacing: 22) {
                        
                            HStack(spacing: 15) {
                                
                                AnimatedImage(url: URL(string: request.coverPhoto))
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    if requestType == .pending {
                                        Text("Request from \(request.firstName)").bold()
                                            .modifier(ModifierInDetailExperienceArtistView())
                                        
                                    } else if requestType == .coming {
                                        Text("Ready to meet \(request.firstName)?").bold()
                                            .modifier(ModifierInDetailExperienceArtistView())
                                        
                                    } else {
                                        if request.accepted {
                                            Text("You have met \(request.firstName)").bold()
                                                .modifier(ModifierInDetailExperienceArtistView())
                                        } else {
                                            Text("You have declined \(request.firstName)").bold()
                                                .modifier(ModifierInDetailExperienceArtistView())
                                        }
                                    }
                                    
                                    Text("At \(request.city)")
                                        .foregroundColor(.black).opacity(0.6)
                                        .font(Font.system(size: 15).italic())
                                        .lineLimit(1)
                                }
                            }
                            
                            HStack {
                                    
                                Button {
                                    isLoading = true
                                    requestArtistCollectionViewModel.acceptPendingRequest(documentId: request.requestId) {
                                        requestUserCollectionViewModel.acceptPendingRequest(documentId: request.requestIdUser) {
                                            requestArtistCollectionViewModel.orderRequestsInDatabase(documentId: artistCollectionViewModel.artist.id, titleFieldToInsert: "comingRequest", titleFieldToRemove: "pendingRequest", element: request.requestId) {
                                                requestUserCollectionViewModel.orderRequestsInDatabase(documentId: request.idUser, titleFieldToInsert: "comingRequest", titleFieldToRemove: "pendingRequest", element: request.requestIdUser) {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                        message = "Request successfully accepted!"
                                                        isShowingAlert = true
                                                        isLoading = false
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    LabelButtonInDetailExperienceArtistView(imageName: "checkmark", color: .checkGreen, text: "Accept")
                                }
                                    
                                Spacer()
                                    
                                Button {
                                    isLoading = true
                                    requestArtistCollectionViewModel.orderRequestsInDatabase(documentId: artistCollectionViewModel.artist.id, titleFieldToInsert: "previousRequest", titleFieldToRemove: "pendingRequest", element: request.requestId) {
                                        requestUserCollectionViewModel.orderRequestsInDatabase(documentId: request.idUser, titleFieldToInsert: "previousRequest", titleFieldToRemove: "pendingRequest", element: request.requestIdUser) {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                message = "You have declined this request."
                                                isShowingAlert = true
                                                isLoading = false
                                            }
                                        }
                                    }
                                } label: {
                                    LabelButtonInDetailExperienceArtistView(imageName: "xmark", color: .mainRed, text: "Decline")
                                }
                            }.isHidden(requestType == .pending ? false : true)
                            .padding(.horizontal, 48)
                        }
                        
                        VStack(alignment: .leading, spacing: 25) {
                            
                            CustomRectangleInDetailRequest()
                            
                            VStack(alignment: .leading, spacing: 22) {
                                Text("Booking information")
                                    .font(.system(size: 19)).bold()
                                    .foregroundColor(.black)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    CustomTitleInDetailExperienceArtistView(text: "Date")
                                    
                                    Text(convertedDate)
                                        .foregroundColor(.black).opacity(0.4)
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    CustomTitleInDetailExperienceArtistView(text: "Location")
                                    
                                    if request.location == "Your place" {
                                        Text("Audience's place")
                                            .foregroundColor(.black).opacity(0.4)
                                    } else {
                                        Text("Your place")
                                            .foregroundColor(.black).opacity(0.4)
                                    }
                                }
                                
                                if request.location == "Your place" {
                                    VStack(alignment: .leading, spacing: 6) {
                                        CustomTitleInDetailExperienceArtistView(text: "Address")
                                        
                                        Text(request.address)
                                            .foregroundColor(.black).opacity(0.4)
                                    }
                                }
                                
                                if request.guest == "1" {
                                    CustomTitleInDetailExperienceArtistView(text: "Guest: \(request.guest)")

                                } else {
                                    CustomTitleInDetailExperienceArtistView(text: "Guests: \(request.guest)")
                                }
                            }.padding(.horizontal, 20)
                            
                            CustomRectangleInDetailRequest()
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Message received")
                                    .font(.system(size: 19)).bold()
                                    .foregroundColor(.black)
                        
                                Text(request.message).italic()
                                    .foregroundColor(.black)
                                    .opacity(0.9)
                                    .font(.footnote)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 16)
                                                .foregroundColor(.lightGrayForBackground.opacity(0.5)))
                                    .overlay(RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.black.opacity(0.8), lineWidth: 1))
                            }.padding(.horizontal, 20)
                        }.padding(.top, requestType == .pending ? 0 : -60)
                    }
                }.padding(.top, 15)
            }.isHidden(isLoading ? true : false)
            .alert(message, isPresented: $isShowingAlert) {
                Button("OK", role: .cancel) {
                    showMainArtist = true
                }
            }
            .fullScreenCover(isPresented: $showMainArtist) {
                ArtistTabView()
            }
        }
    }
}

struct DetailExperienceArtistView_Previews: PreviewProvider {
    static var previews: some View {
        DetailExperienceArtistView(artistCollectionViewModel: ArtistCollectionViewModel(), requestArtistCollectionViewModel: RequestArtistCollectionViewModel(), request: .constant(RequestArtist(requestId: "", requestIdUser: "", idUser: "", firstName: "", city: "", department: "", address: "", date: "", location: "", guest: "", message: "", coverPhoto: "", accepted: false)), requestType: .constant(RequestType.previous), convertedDate: .constant(""))
    }
}

// MARK: - Refactoring structures

struct ModifierInDetailExperienceArtistView: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black).opacity(0.8)
            .font(.title2)
            .lineLimit(2)
            .multilineTextAlignment(.center)
    }
}

struct CustomTitleInDetailExperienceArtistView: View {
    var text: String
     
    var body: some View {
        Text(text)
            .font(.system(size: 17)).bold()
            .foregroundColor(.black).opacity(0.9)
    }
}

struct LabelButtonInDetailExperienceArtistView: View {
    var imageName: String
    var color: Color
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(color)
                .font(.system(size: 20))
        
            Text(text).bold()
                .foregroundColor(color)
                .font(.system(size: 18))
        }.padding(6)
        .background(RoundedRectangle(cornerRadius: 16)
                        .frame(width: 135)
                        .foregroundColor(.lightGrayForBackground).opacity(0.4)
        .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 0.5)))
    }
}
