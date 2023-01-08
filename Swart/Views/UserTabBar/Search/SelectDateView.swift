//
//  SelectDateView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 09/01/2022.
//

import SwiftUI
import ActivityIndicatorView

// Fourth search view where user can decide a date for the performance or to follow artist availabilities.
// Before going to the next view, launch artist search according to user's chosen filters and store in an array the result.
struct SelectDateView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var calendarViewModel = CalendarViewModel()
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @Binding var selectedArtName: String
    @Binding var selectedDepartments: [String]
    @Binding var selectedPlaceNameForFilter: String
    @Binding var selectedPlaceName: String
    @Binding var fromAddressView: Bool

    @State private var currentDate = Date()
    @State private var currentIndexMonth = 0
    @State private var currentYear = 0
    @State private var showSheet = false
    @State private var todaysYear = 0
    @State private var hasEdited = false
    @State private var selectedDate = ""
    @State private var selectedDateForRequest = ""
    @State private var selectedDatesForDetailView: [String] = []
    @State private var isLinkActive = false
    @State private var listedArtists: [Artist] = []
    @State private var isLoading = false
    @State private var isShowMain = false
    
    // MARK: - Body
    
    var body: some View {

        ZStack {
            
            BackgroundForArtistForm()
            
            GeometryReader { geometry in
                ActivityIndicatorView(isVisible: $isLoading, type: .arcs)
                    .foregroundColor(.white)
                    .frame(width: 70, height: 70, alignment: .center)
                    .isHidden(isLoading ? false : true)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        
            VStack {
    
               Spacer()
                
                ZStack {
                    
                    VStack {
                        
                        HStack {
                        
                            TitleForArtistForm(text: "When will you be there?")
                                
                            Spacer()
                            
                        }.padding(.horizontal, 12)
                        
                        ScrollView {
                        
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(height: UIScreen.main.bounds.height / 1.15)
                                    .foregroundColor(Color.white)
                        
                                VStack(alignment: .leading, spacing: 20) {
                                    
                                    ZStack {
                                        
                                        HStack {
                                            Text(selectedArtName)
                                                .fontWeight(.semibold)
                                                .font(.system(size: 19))
                                                .gradientForeground(colors: [Color(#colorLiteral(red: 0.7496727109, green: 0.1164080873, blue: 0.1838892698, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1))])
                                        }
                                    
                                        HStack {
                                            Button {
                                                if fromAddressView {
                                                   isShowMain = true
                                                } else {
                                                    presentationMode.wrappedValue.dismiss()
                                                }
                                            } label: {
                                                Image(systemName: "chevron.backward")
                                                    .foregroundColor(.black).opacity(0.6)
                                                    .font(.system(size: 19))
                                            }
                                            Spacer()
                                        }.padding(.horizontal, 12)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 15) {
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
                                                            
                                                        CustomTextForFutureDatesInUserForm(date: value.day, selectedDate: selectedDate, extractTodaysDate: calendarViewModel.extractTodaysDate(currentDate))
                                                            .onTapGesture {
                                                                onTapGesture(value: value.day)
                                                            }
                                                                
                                                    } else if currentYear < todaysYear {
                                                                
                                                        Text("\(value.day)")
                                                            .modifier(ModifierForPastDates())
                                                                
                                                    } else {
                                                                
                                                        if calendarViewModel.currentMonth < calendarViewModel.todaysMonth {
                                                                        
                                                            Text("\(value.day)")
                                                                .modifier(ModifierForPastDates())
                                                
                                                        } else if calendarViewModel.currentMonth > calendarViewModel.todaysMonth {
                                                                    
                                                            CustomTextForFutureDatesInUserForm(date: value.day, selectedDate: selectedDate, extractTodaysDate: calendarViewModel.extractTodaysDate(currentDate))
                                                                .onTapGesture {
                                                                    onTapGesture(value: value.day)
                                                                }
                                                        } else {
                                                            
                                                            if calendarViewModel.todaysDate == value.day {
                                                                
                                                                CustomTextForFutureDatesInUserForm(date: value.day, selectedDate: selectedDate, extractTodaysDate: calendarViewModel.extractTodaysDate(currentDate))
                                                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                                                                .stroke(Color.black, lineWidth: 1.5))
                                                                    .onTapGesture {
                                                                        onTapGesture(value: value.day)
                                                                    }
                                                                
                                                            } else {
                                                                
                                                                Text("\(value.day)")
                                                                    .foregroundColor(value.day < calendarViewModel.todaysDate ? .lightGray : .black)
                                                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                                                            .stroke(Color.lightGray, lineWidth: 1))
                                                                    .overlay(Circle()
                                                                            .stroke(Color.black, lineWidth: 1)
                                                                                .isHidden(selectedDate == String(value.day) + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])" ? false : true))
                                                                    .onTapGesture {
                                                                        if value.day >= calendarViewModel.todaysDate {
                                                                            onTapGesture(value: value.day)
                                                                        }
                                                                    }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }.padding(.horizontal, 9)
                                    }
                                    Spacer()
                                }.padding(.top, 20)
                            }
                        }.padding(.bottom, 85)
                    }
                    
                    VStack {
                        Spacer()
                        
                        ZStack {
                            Rectangle()
                                .border(Color.secondary)
                                .frame(height: 90)
                                .foregroundColor(.white)
                            
                            HStack {
                                
                                Button {
                                    isLoading = true
                                    artistCollectionViewModel.researchFilteredArtists(art: selectedArtName, department: selectedDepartments, place: selectedPlaceNameForFilter) {
                                        isLinkActive = true
                                        isLoading = false
                                    }
                                    
                                } label: {
                                    Text("I'm flexible").underline()
                                        .foregroundColor(.black)
                                }.background(NavigationLink("", destination: PresentArtistsView(artistCollectionViewModel: artistCollectionViewModel, selectedArtName: $selectedArtName, selectedDate: $selectedDate, selectedDateForRequest: $selectedDateForRequest, selectedPlaceName: $selectedPlaceName), isActive: $isLinkActive))

                                Spacer()
                                
                                Button {
                                    isLoading = true
                                    artistCollectionViewModel.researchFilteredArtistsWithGivenDate(art: selectedArtName, department: selectedDepartments, place: selectedPlaceNameForFilter, selectedDate: selectedDate) {
                                        isLinkActive = true
                                        isLoading = false
                                    }
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 115, height: 45)
                                            .foregroundColor(.mainRed)
                                            .opacity(selectedDate == "" ? 0.2 : 0.8)
                                    
                                        HStack {
                                            Image(systemName: "magnifyingglass")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                            
                                            Text("Search").bold()
                                                .font(.system(size: 17))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }.disabled(selectedDate == "" ? true : false)
                            }.padding(.horizontal)
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
                }.fullScreenCover(isPresented: $isShowMain) {
                    UserTabView()
                }
            }.isHidden(isLoading ? true : false)
            .edgesIgnoringSafeArea(.bottom)
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
    
    // MARK: - Method
    
    private func onTapGesture(value: Int) {
        if selectedDate != String(value) + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])" {
            selectedDate = String(value) + "\(calendarViewModel.extractTodaysDate(currentDate)[0])" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])"
            
            if let month = CalendarViewModel.months[calendarViewModel.extractTodaysDate(currentDate)[0]] {
                selectedDateForRequest = month + "/" + String(value) + "/" + "\(calendarViewModel.extractTodaysDate(currentDate)[1])"
            }
            
            hasEdited = true
        } else {
            selectedDate = ""
            selectedDateForRequest = ""
            hasEdited = false
        }
    }
}

struct SelectDateView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDateView(selectedArtName: .constant(""), selectedDepartments: .constant([]), selectedPlaceNameForFilter: .constant(""), selectedPlaceName: .constant(""), fromAddressView: .constant(false))
    }
}
