//
//  ExperiencesArtistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 09/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

// First artist tab where all artist requests are displayed and divided into three kind: pending, coming and previous.
// Artist can navigate and choose the request he wants to consult.
struct ExperiencesArtistView: View {
    
    // MARK: - Properties
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    @ObservedObject var requestArtistCollectionViewModel: RequestArtistCollectionViewModel
    
    @State private var selectedRequest = RequestArtist(requestId: "", requestIdUser: "", idUser: "", firstName: "", city: "", department: "", address: "", date: "", location: "", guest: "", message: "", coverPhoto: "", accepted: false)
    @State private var isPresented = false
    @State private var requestType = RequestType.pending
    @State private var convertedDate = ""
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.white
                    .ignoresSafeArea()
                
                if requestType == .pending {
                    CustomNoRequestArtistFoundText(text: "No pending requests found.", requests: requestArtistCollectionViewModel.pendingRequests)
        
                } else if requestType == .coming {
                    CustomNoRequestArtistFoundText(text: "No performances planned on next months.", requests: requestArtistCollectionViewModel.comingRequests)
                    
                } else {
                    CustomNoRequestArtistFoundText(text: "No previous performances found.", requests: requestArtistCollectionViewModel.previousRequests)
                }
            
                VStack {
                    
                    HStack(spacing: 18) {
                        
                        CustomRequestTypeButton(requestType: $requestType, type: .pending, title: "Pending")
                        
                        CustomRequestTypeButton(requestType: $requestType, type: .coming, title: "Coming")
                        
                        CustomRequestTypeButton(requestType: $requestType, type: .previous, title: "Previous")
                        
                        Spacer()
                        
                    }.padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    ZStack {
                    
                        List(requestArtistCollectionViewModel.pendingRequests, id: \.self) { request in
                            
                            Button {
                                withAnimation {
                                    selectedRequest = request
                                    _ = convertDate(date: request.date)
                                    isPresented = true
                                }
                            } label: {
                                    
                                ListLabelView(coverPhoto: request.coverPhoto, firstName: request.firstName, city: request.city, message: "Waiting for your confirmation", isAccepted: request.accepted, requestType: requestType)
                            }.listRowBackground(Color.lightGrayForBackground.opacity(0.6))
                        }.isHidden(requestType == .pending ? false : true)
                        
                        List(requestArtistCollectionViewModel.comingRequests, id: \.self) { request in
                            
                            Button {
                                withAnimation {
                                    selectedRequest = request
                                    _ = convertDate(date: request.date)
                                    isPresented = true
                                }
                            } label: {
                                    
                                ListLabelView(coverPhoto: request.coverPhoto, firstName: request.firstName, city: request.city, message: convertDate(date: request.date), isAccepted: request.accepted, requestType: requestType)
                            }.listRowBackground(Color.lightGrayForBackground.opacity(0.6))
                        }.isHidden(requestType == .coming ? false : true)
                        
                        List(requestArtistCollectionViewModel.previousRequests, id: \.self) { request in
                            
                            Button {
                                withAnimation {
                                    selectedRequest = request
                                    _ = convertDate(date: request.date)
                                    isPresented = true
                                }
                            } label: {
                                    
                                ListLabelView(coverPhoto: request.coverPhoto, firstName: request.firstName, city: request.city, message: request.accepted ? "Performed on \(convertDate(date: request.date))" : "Request declined", isAccepted: request.accepted, requestType: requestType)
                            }.listRowBackground(Color.lightGrayForBackground.opacity(0.6))
                        }.isHidden(requestType == .previous ? false : true)
                    }.isHidden(requestType == .pending && requestArtistCollectionViewModel.pendingRequests.isEmpty ? true : false)
                    .isHidden(requestType == .coming && requestArtistCollectionViewModel.comingRequests.isEmpty ? true : false)
                    .isHidden(requestType == .previous && requestArtistCollectionViewModel.previousRequests.isEmpty ? true : false)
                    .fullScreenCover(isPresented: $isPresented, content: {
                        DetailExperienceArtistView(artistCollectionViewModel: artistCollectionViewModel, requestArtistCollectionViewModel: requestArtistCollectionViewModel, request: $selectedRequest, requestType: $requestType, convertedDate: $convertedDate)
                    })
                }
            }.onAppear {
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            }
            .navigationTitle("Next Performances")
        }.navigationViewStyle(.stack)
    }
    
    // MARK: - Method
    
    private func convertDate(date: String) -> String {
        let array = date.components(separatedBy: "/")
        if let month = CalendarViewModel.monthsNumber[array[0]] {
            convertedDate = array[1] + " " + month
            return array[1] + " " + month + " " + array[2]
        }
        return ""
    }
}

struct ExperiencesArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ExperiencesArtistView(artistCollectionViewModel: ArtistCollectionViewModel(), requestArtistCollectionViewModel: RequestArtistCollectionViewModel())
    }
}

// MARK: - Refactoring structures

struct CustomNoRequestArtistFoundText: View {
    
    var text: String
    var requests: [RequestArtist]
    
    var body: some View {
        
        Text(text)
            .font(Font.system(size: 18).italic())
            .foregroundColor(.black).opacity(0.9)
            .multilineTextAlignment(.center)
            .isHidden(requests.isEmpty ? false : true)
    }
}

struct ListLabelView: View {
    
    var coverPhoto: String
    var firstName: String
    var city: String
    var message: String
    var isAccepted: Bool
    var requestType: RequestType
    
    var body: some View {
        
        HStack {
            
            AnimatedImage(url: URL(string: coverPhoto))
                .resizable()
                .frame(width: 90, height: 90)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text(firstName).bold()
                    .foregroundColor(.black).opacity(0.8)
                    .font(.system(size: 15))
                    .lineLimit(1)
                
                Text(city)
                    .foregroundColor(.black).opacity(0.6)
                    .font(Font.system(size: 15))
                    .lineLimit(1)
                
                if requestType == .pending {
                    Text(message).italic().bold()
                        .font(.system(size: 14))
                        .foregroundColor(.pendingOrange)
                } else if requestType == .coming {
                    Text(message).italic().bold()
                        .font(.system(size: 14))
                        .foregroundColor(.checkGreen)
                } else {
                    Text(message).italic().bold()
                        .font(.system(size: 14))
                        .foregroundColor(isAccepted ? .checkGreen : .mainRed)
                }
            }.padding(.leading, 2)
        }
    }
}
