//
//  ExperiencesView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

// Third user tab where all user requests are displayed and divided into three kind: pending, coming and previous. User can navigate and choose the request he wants to consult.
struct ExperiencesView: View {
    
    // MARK: - Properties
    
    @ObservedObject var userCollectionViewModel: UserCollectionViewModel
    @ObservedObject var requestUserCollectionViewModel: RequestUserCollectionViewModel
    
    @State private var selectedRequest = RequestUser(requestId: "", headline: "", city: "", department: "", address: "", date: "", location: "", guest: "", coverPhoto: "", accepted: true)
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
                    CustomNoRequestFoundText(text: "No pending requests found.", requests: requestUserCollectionViewModel.pendingRequests)
                    
                } else if requestType == .coming {
                    CustomNoRequestFoundText(text: "No performances planned on next months.", requests: requestUserCollectionViewModel.comingRequests)
                    
                } else {
                    CustomNoRequestFoundText(text: "No previous performances found.", requests: requestUserCollectionViewModel.previousRequests)
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
                    
                        List(requestUserCollectionViewModel.pendingRequests, id: \.self) { request in
                            
                            VStack(alignment: .leading) {
                                
                                Button {
                                    withAnimation {
                                        selectedRequest = request
                                        _ = convertDate(date: request.date)
                                        isPresented = true
                                    }
                                } label: {
                                    
                                    ListLabelForUserView(coverPhoto: request.coverPhoto, headline: request.headline, city: request.city, message: "Waiting for confirmation", isAccepted: request.accepted, requestType: requestType)
                                }
                            }.listRowBackground(Color.lightGrayForBackground.opacity(0.6))
                        }.isHidden(requestType == .pending ? false : true)
                        
                        List(requestUserCollectionViewModel.comingRequests, id: \.self) { request in
                            
                            VStack(alignment: .leading) {
                                
                                Button {
                                    withAnimation {
                                        selectedRequest = request
                                        _ = convertDate(date: request.date)
                                        isPresented = true
                                    }
                                } label: {
                                    
                                    ListLabelForUserView(coverPhoto: request.coverPhoto, headline: request.headline, city: request.city, message: convertDate(date: request.date), isAccepted: request.accepted, requestType: requestType)
                                }
                            }.listRowBackground(Color.lightGrayForBackground.opacity(0.6))
                        }.isHidden(requestType == .coming ? false : true)
                        
                        List(requestUserCollectionViewModel.previousRequests, id: \.self) { request in
                            
                            VStack(alignment: .leading) {
                                
                                Button {
                                    withAnimation {
                                        selectedRequest = request
                                        _ = convertDate(date: request.date)
                                        isPresented = true
                                    }
                                } label: {
                                    
                                    ListLabelForUserView(coverPhoto: request.coverPhoto, headline: request.headline, city: request.city, message: request.accepted ? "\(convertDate(date: request.date))" : "Request declined", isAccepted: request.accepted, requestType: requestType)
                                }
                            }.listRowBackground(Color.lightGrayForBackground.opacity(0.6))
                        }.isHidden(requestType == .previous ? false : true)
                    }.isHidden(requestType == .pending && requestUserCollectionViewModel.pendingRequests.isEmpty ? true : false)
                    .isHidden(requestType == .coming && requestUserCollectionViewModel.comingRequests.isEmpty ? true : false)
                    .isHidden(requestType == .previous && requestUserCollectionViewModel.previousRequests.isEmpty ? true : false)
                    .fullScreenCover(isPresented: $isPresented, content: {
                        DetailExperienceView(request: $selectedRequest, convertedDate: $convertedDate)
                    })
                }
            }.onAppear {
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            }
            .navigationTitle("Experiences")
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

struct ExperiencesView_Previews: PreviewProvider {
    static var previews: some View {
        ExperiencesView(userCollectionViewModel: UserCollectionViewModel(), requestUserCollectionViewModel: RequestUserCollectionViewModel())
    }
}

// MARK: - Refactoring structures

struct CustomNoRequestFoundText: View {
    
    var text: String
    var requests: [RequestUser]
    
    var body: some View {
        
        Text(text)
            .font(Font.system(size: 18).italic())
            .foregroundColor(.black).opacity(0.9)
            .multilineTextAlignment(.center)
            .isHidden(requests.isEmpty ? false : true)
    }
}

struct CustomRequestTypeButton: View {
    
    @Binding var requestType: RequestType
    var type: RequestType
    var title: String
    
    var body: some View {
        
        Button {
            requestType = type
        } label: {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 80, height: 30)
                .foregroundColor(.lightGrayForBackground)
                .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(requestType == type ? Color.black : Color.gray.opacity(0.3), lineWidth: 1))
                .overlay(Text(title).bold()
                            .foregroundColor(.black)
                            .opacity(requestType == type ? 1 : 0.3)
                            .font(.system(size: 14)))
        }
    }
}

struct ListLabelForUserView: View {
    
    var coverPhoto: String
    var headline: String
    var city: String
    var message: String
    var isAccepted: Bool
    var requestType: RequestType
    
    var body: some View {
        
        HStack {
            
            AnimatedImage(url: URL(string: coverPhoto))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 125, height: 115, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 25) {
                
                Text(headline).bold()
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
