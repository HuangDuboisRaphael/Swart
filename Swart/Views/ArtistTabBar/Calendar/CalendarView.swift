//
//  CalendarView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 26/12/2021.
//

import SwiftUI

// Second artist tab where the artist can look at his personal calendar and select one or several dates to inform users about his availabilities and unavailabilities.
struct CalendarView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    @State private var currentDate = Date()
    @State private var currentIndexMonth = 0
    @State private var currentYear = 0
    @State private var showSheet = false
    @State private var todaysYear = 0
    @State private var hasEdited = false
    @State private var selectedDates: [String] = []
    @State private var selectedDatesForDetailView: [String] = []
    
    // MARK: - Body

    var body: some View {
            
        NavigationView {
            
            ZStack {
                
                Color.white
                    .ignoresSafeArea()
            
                ScrollView {
                           
                    VStack(spacing: 15) {
                        
                        CustomDatedStack(extractTodaysYear: calendarViewModel.extractTodaysDate(currentDate)[1], extractTodaysMonth: calendarViewModel.extractTodaysDate(currentDate)[0], currentIndexMonth: $currentIndexMonth, currentMonth: $calendarViewModel.currentMonth)
                                    
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
                                            
                                                if calendarViewModel.blockedDates.contains(convertDateToString(value: String(value.day))) {
                                                
                                                    CustomTextForBlockedDates(date: value.day, todaysDate: calendarViewModel.todaysDate, todaysMonth: calendarViewModel.todaysMonth, currentMonth: calendarViewModel.currentMonth, selectedDates: selectedDates, extractTodaysDate: calendarViewModel.extractTodaysDate(currentDate))
                                                        .onTapGesture {
                                                            onTapGesture(value: value.day)
                                                        }
                                                } else {
                                                    CustomTextForFutureDates(date: value.day, selectedDates: selectedDates, extractTodaysDate: calendarViewModel.extractTodaysDate(currentDate))
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
                    }.padding(.top, 10)
                    Spacer()
                }
                    
                VStack {
                    
                    Spacer()
                
                    Button {
                        selectedDatesForDetailView = selectedDates
                        showSheet = true
                    } label: {
                        
                        HStack {
                            Spacer()
                                    
                            ZStack {
                                RoundedRectangle(cornerRadius: 40)
                                    .frame(width: 90, height: 48)
                                    .foregroundColor(.mainRed)
                                        
                                HStack {
                                    Text("Edit")
                                        .font(.system(size: 18)).bold()
                                        .foregroundColor(.white)
                                        
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }.isHidden(hasEdited ? false : true)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                }
            }
            .sheet(isPresented: $showSheet, content: {
                DetailSelectedDatesView(calendarViewModel: calendarViewModel, selectedDates: $selectedDates, selectedDatesForDetailView: $selectedDatesForDetailView, hasEdited: $hasEdited)
            })
            .onAppear(perform: {
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
                
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
            }.navigationBarTitle("Set your agenda")
        }.navigationViewStyle(.stack)
    }
    
    // MARK: - Methods
    
    private func getDatesView(date: Int) -> AnyView {
        
        if calendarViewModel.blockedDates.contains(convertDateToString(value: String(date))) {
            
            return AnyView(CustomTextForBlockedDates(date: date, todaysDate: calendarViewModel.todaysDate, todaysMonth: calendarViewModel.todaysMonth, currentMonth: calendarViewModel.currentMonth, selectedDates: selectedDates, extractTodaysDate: calendarViewModel.extractTodaysDate(currentDate))
                .onTapGesture {
                    onTapGesture(value: date)
                })
            
        } else {
            
            return AnyView(CustomTextForFutureDates(date: date, selectedDates: selectedDates, extractTodaysDate: calendarViewModel.extractTodaysDate(currentDate))
                .onTapGesture {
                    onTapGesture(value: date)
                })
        }
    }
    
    private func onTapGesture(value: Int) {
        if !selectedDates.contains(String(value) + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])") {
                
            hasEdited = true
                
            selectedDates.append(String(value) + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])")
            
        } else if selectedDates.contains(String(value) + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])") && selectedDates.count > 1 {
                
            let day = String(value) + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])"
            if selectedDates.contains(day) {
                let index = selectedDates.firstIndex(of: day)
                selectedDates.remove(at: index!)
            }
        } else {
            let day = String(value) + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])"
            if selectedDates.contains(day) {
                let index = selectedDates.firstIndex(of: day)
                selectedDates.remove(at: index!)
            }
            hasEdited = false
        }
    }
    
    private func convertDateToString(value: String) -> String {
        return "\(value)" + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])"
    }
    
    private func isEditing(day: String) -> Bool {
        if hasEdited && selectedDates.contains(day) {
            return true
        } else {
            return false
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(calendarViewModel: CalendarViewModel())
    }
}

// MARK: - Refactoring structures

struct ModifierForPastDates: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.lightGray)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.lightGray, lineWidth: 1))
    }
}

struct ModifierForFutureDates: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.lightGray, lineWidth: 1))
    }
}
