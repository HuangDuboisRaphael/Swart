//
//  DatesFormattersViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 25/09/2021.
//

import SwiftUI

// Various methods to check if user is an adult.
class DatesFormattersViewModel {
    
    func userIs18(birthdate: Date) -> Bool {
        let isAdult: Bool
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let today = formatter.string(from: now)
        let birthday = formatter.string(from: birthdate)
        
        let currentYear = isolateYearFromGivenDate(date: today)
        let birthdayYear = isolateYearFromGivenDate(date: birthday)
        
        let currentMonth = isolateMonthFromGivenDate(date: today)
        let birthdayMonth = isolateMonthFromGivenDate(date: birthday)
        
        let currentDay = isolateDayFromGivenDate(date: today)
        let birthdayDay = isolateDayFromGivenDate(date: birthday)
        
        if Int(currentYear)! - Int(birthdayYear)! < 18 {
            isAdult = false
        } else if Int(currentYear)! - Int(birthdayYear)! == 18 {
            if Int(currentMonth)! < Int(birthdayMonth)! {
                isAdult = false
            } else {
                if Int(currentMonth)! == Int(birthdayMonth)! {
                    if Int(currentDay)! < Int(birthdayDay)! {
                        isAdult = false
                    } else {
                        isAdult = true
                    }
                } else {
                    isAdult = true
                }
            }
        } else {
            isAdult = true
        }
        return isAdult
    }
    
    func isolateYearFromGivenDate(date: String) -> String {
        let startYear = date.index(date.startIndex, offsetBy: 6)
        let endYear = date.index(date.startIndex, offsetBy: 10)
        let year = startYear..<endYear
        return String(date[year])
    }
    
    func isolateMonthFromGivenDate(date: String) -> String {
        let startMonth = date.index(date.startIndex, offsetBy: 0)
        let endMonth = date.index(date.startIndex, offsetBy: 2)
        let month = startMonth..<endMonth
        return String(date[month])
    }
    
    func isolateDayFromGivenDate(date: String) -> String {
        let startDay = date.index(date.startIndex, offsetBy: 3)
        let endDay = date.index(date.startIndex, offsetBy: 5)
        let day = startDay..<endDay
        return String(date[day])
    }
}
