//
//  DetailExperienceView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 08/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

// To preview the user selected request and all the booking information related to it.
struct DetailExperienceView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @Binding var request: RequestUser
    @Binding var convertedDate: String

    @State private var bookingDate = ""
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
        
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
                        
                        VStack(spacing: 15) {
                        
                            HStack(spacing: 15) {
                                
                                AnimatedImage(url: URL(string: request.coverPhoto))
                                    .resizable()
                                    .frame(width: 85, height: 85)
                                    .clipShape(Circle())
                                
                                VStack(spacing: 5) {
                                    
                                    Text(request.headline).bold()
                                        .foregroundColor(.black).opacity(0.8)
                                        .font(.title3)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("At \(request.city)")
                                        .foregroundColor(.black).opacity(0.6)
                                        .font(Font.system(size: 15).italic())
                                        .lineLimit(1)
                                }
                            }.padding(.horizontal, 20)
                        }
                        
                        VStack(alignment: .leading, spacing: 25) {
                            
                            CustomRectangleInDetailRequest()
                            
                            VStack(alignment: .leading, spacing: 22) {
                            
                                Text("Booking information")
                                    .font(.system(size: 19)).bold()
                                    .foregroundColor(.black)
                                
                                CustomVStackInRequestToBookView(title: "Date", text: convertedDate)
                                
                                CustomVStackInRequestToBookView(title: "Location", text: request.location)
                                
                                if request.location != "Your place" {
                                    VStack(alignment: .leading, spacing: 6) {
                                        
                                        Text("Address")
                                            .font(.system(size: 17)).bold()
                                            .foregroundColor(.black).opacity(0.9)
                                        
                                        Text(request.address)
                                            .foregroundColor(.black).opacity(0.4)
                                    }
                                }
                                
                                if request.guest == "1" {
                                    Text("Guest: \(request.guest)")
                                        .font(.system(size: 17)).bold()
                                        .foregroundColor(.black).opacity(0.9)
                                } else {
                                    Text("Guests: \(request.guest)")
                                        .font(.system(size: 17)).bold()
                                        .foregroundColor(.black).opacity(0.9)
                                }
                            }.padding(.horizontal, 20)
                        }
                    }
                }.padding(.top, 15)
            }.onAppear(perform: {
                let array = request.date.components(separatedBy: "/")
                if let month = CalendarViewModel.monthsNumber[array[0]] {
                    bookingDate =  array[1] + " " + month + " " + array[2]
                }
            })
        }
    }
}

struct DetailExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        DetailExperienceView(request: .constant(RequestUser(requestId: "", headline: "", city: "", department: "", address: "", date: "", location: "", guest: "", coverPhoto: "", accepted: false)), convertedDate: .constant(""))
    }
}

// MARK: - Refactoring structure

struct CustomRectangleInDetailRequest: View {
    var body: some View {
        Rectangle()
            .frame(height: 10)
            .foregroundColor(.gray).opacity(0.3)
    }
}
