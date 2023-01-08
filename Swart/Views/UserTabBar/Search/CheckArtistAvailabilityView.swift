//
//  CheckArtistAvailabilityInFormView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 04/02/2022.
//

import SwiftUI

// If no performance date was chosen, user needs in this view to choose a date according to selected artist's availabilities.
struct CheckArtistAvailabilityView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var calendarViewModel = CalendarViewModel()
    
    @Binding var selectedArtist: Artist
    @Binding var selectedDate: String
    @Binding var hasSelectedADate: Bool
    @Binding var showSheet: Bool
    @Binding var selectedDateForRequest: String
    
    @State private var currentDate = Date()
    @State private var currentIndexMonth = 0
    @State private var currentYear = 0
    @State private var todaysYear = 0
    @State private var listedArtists: [Artist] = []
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
                
            ScrollView {
                
                VStack(alignment: .leading, spacing: 15) {

                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.black).opacity(0.6)
                                .font(.system(size: 19))
                        }
                        Spacer()
                    }.padding(.horizontal, 12)
                            
                    VStack(alignment: .leading) {
                                
                        Text("Select a date").bold()
                            .font(.title)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 15) {
                                                
                            CustomDatedStack(extractTodaysYear: calendarViewModel.extractTodaysDate(currentDate)[1], extractTodaysMonth: calendarViewModel.extractTodaysDate(currentDate)[0], currentIndexMonth: $currentIndexMonth, currentMonth: $calendarViewModel.currentMonth)
                                .padding(.top, 25)
                                                    
                            HStack(spacing: 0) {
                                ForEach(CalendarViewModel.days, id: \.self) { day in
                                                        
                                    Text(day)
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                }
                            }.padding(.horizontal, 5)
                                                    
                            let columns = Array(repeating: GridItem(.flexible()), count: 7)
                                                    
                            LazyVGrid(columns: columns, spacing: 20) {
                                                        
                                ForEach(calendarViewModel.days, id: \.self) { value in
                                                            
                                    if value.day == -1 {
                                                                
                                        Text("\(value.day)")
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                            .foregroundColor(.white)
                
                                    } else {
                                                
                                        if currentYear > todaysYear {
                                            getDatesView(date: value.day)
                                                                
                                        } else if currentYear < todaysYear {
                                                                
                                            Text("\(value.day)")
                                                .modifier(ModifierForPastDates())
                                                                
                                        } else {
                                                                
                                            if calendarViewModel.currentMonth < calendarViewModel.todaysMonth {
                                                                        
                                                Text("\(value.day)")
                                                    .modifier(ModifierForPastDates())
                                                
                                                } else if calendarViewModel.currentMonth > calendarViewModel.todaysMonth {
                                                    getDatesView(date: value.day)
                                                        
                                            } else {
                                                            
                                                if calendarViewModel.todaysDate == value.day {
                                                            
                                                    if selectedArtist.blockedDates.contains(convertDateToString(value: String(value.day))) {
                                                                
                                                        CustomTextForBlockedDatesForWishes(date: value.day, todaysDate: calendarViewModel.todaysDate, todaysMonth: calendarViewModel.todaysMonth, currentMonth: calendarViewModel.currentMonth)
                                                                
                                                    } else {
                                                                
                                                        CustomTextForFutureDatesInUserForm(date: value.day, selectedDate: selectedDate, extractTodaysDate: calendarViewModel.extractTodaysDate(currentDate))
                                                            .overlay(RoundedRectangle(cornerRadius: 10)
                                                                            .stroke(Color.black, lineWidth: 1.5))
                                                            .onTapGesture {
                                                                onTapGesture(value: value.day)
                                                            }
                                                    }
                                                } else if calendarViewModel.todaysDate > value.day {
                                                            
                                                    Text("\(value.day)")
                                                        .modifier(ModifierForPastDates())
                                                            
                                                } else {
                                                    getDatesView(date: value.day)
                                                }
                                            }
                                        }
                                    }
                                }
                            }.padding(.horizontal, 9)
                        }
                    }
                    Spacer()
                }.padding(.top, 20)
            }.padding(.bottom, 85)
                    
            VStack {
                Spacer()
                        
                ZStack {
                    Rectangle()
                        .border(Color.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 90)
                        .foregroundColor(.white)
                                
                    HStack {
                        Spacer()
                                    
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 100, height: 45)
                                .foregroundColor(.mainRed)
                                .opacity(selectedDate == "" ? 0.2 : 0.8)
                                        
                            Button {
                                selectedDate = calendarViewModel.convertDateForCheckArtistAvailabilityView(date: selectedDate)
                                hasSelectedADate = true
                                showSheet = false
                            } label: {
                                Text("Save").bold()
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }.disabled(selectedDate == "" ? true : false)
                        }.padding(.top, 10)
                    }.padding()
                    .padding(.top, -20)
                }
            }.onAppear(perform: {
                calendarViewModel.determineTodaysDate(currentDate)
                calendarViewModel.extractDate(currentIndexMonth: currentIndexMonth)
                            
                if let year = Int(calendarViewModel.extractTodaysDate(currentDate)[1]) {
                    todaysYear = year
                    currentYear = year
                }
            })
            .onChange(of: currentIndexMonth) { _ in
                currentDate = calendarViewModel.getCurrentMonth(currentIndexMonth: currentIndexMonth)
                calendarViewModel.extractDate(currentIndexMonth: currentIndexMonth)
                            
                if let year = Int(calendarViewModel.extractTodaysDate(currentDate)[1]) {
                    currentYear = year
                }
            }
        }.edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
    
    // MARK: - Methods
    
    private func getDatesView(date: Int) -> AnyView {
        
        if selectedArtist.blockedDates.contains(convertDateToString(value: String(date))) {
            
            return AnyView(CustomTextForBlockedDatesForWishes(date: date, todaysDate: calendarViewModel.todaysDate, todaysMonth: calendarViewModel.todaysMonth, currentMonth: calendarViewModel.currentMonth))
            
        } else {
            
            return AnyView(CustomTextForFutureDatesInUserForm(date: date, selectedDate: selectedDate, extractTodaysDate: calendarViewModel.extractTodaysDate(currentDate))
                .onTapGesture {
                    onTapGesture(value: date)
                })
        }
    }
    
    private func onTapGesture(value: Int) {
        if selectedDate != String(value) + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])" {
            selectedDate = String(value) + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])"
            
            if let month = CalendarViewModel.months[calendarViewModel.extractTodaysDate(currentDate)[0]] {
                selectedDateForRequest = month + "/" + String(value) + "/" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])"
            }
        } else {
            selectedDate = ""
            selectedDateForRequest = ""
        }
    }
    
    private func convertDateToString(value: String) -> String {
        return "\(value)" + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])"
    }
}
