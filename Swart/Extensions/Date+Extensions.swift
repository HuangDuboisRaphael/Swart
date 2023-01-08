//
//  Date+Extensions.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 23/02/2022.
//

import SwiftUI

// Date extension to get all dates within a month.
extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
