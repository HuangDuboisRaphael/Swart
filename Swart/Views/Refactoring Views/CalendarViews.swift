//
//  ArtistViews.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 02/02/2022.
//

import SwiftUI

// Refactoring structures using in calendar views.
struct CustomTextForBlockedDates: View {
    
    var date: Int
    var todaysDate: Int
    var todaysMonth: Int
    var currentMonth: Int
    var selectedDates: [String]
    var extractTodaysDate: [String]
    
    var body: some View {
        
        Text("\(date)")
            .modifier(ModifierForBlockedDates())
            .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.lightGray, lineWidth: 1)
                    .isHidden(date == todaysDate && currentMonth == todaysMonth ? true : false))
            .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
                    .isHidden(date == todaysDate && currentMonth == todaysMonth ? false : true))
            .overlay(Circle()
                    .stroke(Color.black, lineWidth: 1)
                    .isHidden(selectedDates.contains(String(date) + "\(extractTodaysDate[0])" + "\(extractTodaysDate[1])") ? false : true))
    }
}

struct CustomTextForBlockedDatesForWishes: View {
    
    var date: Int
    var todaysDate: Int
    var todaysMonth: Int
    var currentMonth: Int
    
    var body: some View {
        
        Text("\(date)")
            .modifier(ModifierForBlockedDates())
            .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.lightGray, lineWidth: 1)
                    .isHidden(date == todaysDate && currentMonth == todaysMonth ? true : false))
            .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
                    .isHidden(date == todaysDate && currentMonth == todaysMonth ? false : true))
    }
}

struct CustomTextForFutureDates: View {
    
    var date: Int
    var selectedDates: [String]
    var extractTodaysDate: [String]
    
    var body: some View {
        
        Text("\(date)")
            .modifier(ModifierForFutureDates())
            .overlay(Circle()
                    .stroke(Color.black, lineWidth: 1)
                    .isHidden(selectedDates.contains(String(date) + "\(extractTodaysDate[0])" + "\(extractTodaysDate[1])") ? false : true))
    }
}

struct CustomTextForFutureDatesInUserForm: View {
    
    var date: Int
    var selectedDate: String
    var extractTodaysDate: [String]
    
    var body: some View {
        
        Text("\(date)")
            .modifier(ModifierForFutureDates())
            .overlay(Circle()
                    .stroke(Color.black, lineWidth: 1)
                    .isHidden(selectedDate == (String(date) + "\(extractTodaysDate[0])" + "\(extractTodaysDate[1])") ? false : true))
    }
}

struct CustomDatedStack: View {
    
    var extractTodaysYear: String
    var extractTodaysMonth: String
    @Binding var currentIndexMonth: Int
    @Binding var currentMonth: Int
    
    var body: some View {
        
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text(extractTodaysYear)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Text(extractTodaysMonth)
                    .font(.title.bold())
                    .foregroundColor(.black)
            }
            Spacer()
                        
            Button {
                withAnimation {
                    currentIndexMonth -= 1
                    currentMonth -= 1
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.lightGray)
            }
                        
            Button {
                withAnimation {
                    currentIndexMonth += 1
                    currentMonth += 1
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.lightGray)
            }
        }.padding(.horizontal)
    }
}

struct ModifierForFutureDatesUserInterface: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 45)
            .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.lightGray, lineWidth: 1))
    }
}

struct ModifierForBlockedDates: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.lightGrayForBackground).opacity(0.8))
            .overlay(Image(systemName: "xmark")
                    .font(.system(size: 30))
                    .foregroundColor(.lightGray))
    }
}
