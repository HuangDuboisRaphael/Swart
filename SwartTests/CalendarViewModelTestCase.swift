//
//  CalendarViewModelTestCase.swift
//  SwartTests
//
//  Created by Raphaël Huang-Dubois on 17/03/2022.
//

import XCTest
@testable import Swart

class CalendarViewModelTestCase: XCTestCase {

    private var calendarViewModel: CalendarViewModel!
    
    override func setUp() {
        super.setUp()
        calendarViewModel = CalendarViewModel()
    }
    
    func testGivenFunctionGetCurrentMonth_WhenCall_ThenGetCurrentMonth() {
        let currentIndexMonth = 1
        XCTAssertNotNil(calendarViewModel.getCurrentMonth(currentIndexMonth: currentIndexMonth))
    }
    
    func testGivenFunctionExtractDate_WhenCall_ThenGetAllDates() {
        let currentIndexMonth = 1
        XCTAssertNotNil(calendarViewModel.extractDate(currentIndexMonth: currentIndexMonth))
    }
    
    func testGivenFunctionExtractTodaysDate_WhenCall_ThenGetDateComponents() {
        let stringDate = "01/01/2022"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: stringDate) {
            XCTAssertEqual(calendarViewModel.extractTodaysDate(date), ["January", "2022"])
        }
    }
    
    func testGivenFunctionDetermineTodaysDate_WhenCall_ThenAttributeCorrectDateComponents() {
        let stringDate = "01/10/2022"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: stringDate) {
            calendarViewModel.determineTodaysDate(date)
            XCTAssertTrue(calendarViewModel.todaysMonth == 1)
            XCTAssertTrue(calendarViewModel.currentMonth == 1)
            XCTAssertTrue(calendarViewModel.todaysDate == 10)
        }
    }
    
    func testGivenFunctionConvertDateForPresentArtistView_WhenSelectedDateDigitIsAboveFive_ThenTransformDateCorrectly() {
        let date = "10January2022"
        calendarViewModel.convertDateForPresentArtistView(selectedDate: date) { editedDate in
            XCTAssertEqual(editedDate, "10 January")
        }
    }
    
    func testGivenFunctionConvertDateForPresentArtistView_WhenSelectedDateDigitIsEqualFive_ThenTransformDateCorrectly() {
        let date = "1January2022"
        calendarViewModel.convertDateForPresentArtistView(selectedDate: date) { editedDate in
            XCTAssertEqual(editedDate, "1 January")
        }
    }
    
    func testGivenFunctionConvertDateForPresentArtistView_WhenSelectedDateIsEmptyString_ThenReturnEmptyString() {
        let date = ""
        calendarViewModel.convertDateForPresentArtistView(selectedDate: date) { editedDate in
            XCTAssertEqual(editedDate, "")
        }
    }
    
    func testGivenFunctionConvertDateForCheckArtistAvailabilityView_WhenSelectedDateDigitIsAboveFive_ThenTransformDateCorrectly() {
        let date = "10January2022"
        XCTAssertEqual(calendarViewModel.convertDateForCheckArtistAvailabilityView(date: date), "10 January")
    }
    
    func testGivenFunctionConvertDateForCheckArtistAvailabilityView_WhenSelectedDateDigitIsEqualFive_ThenTransformDateCorrectly() {
        let date = "1January2022"
        XCTAssertEqual(calendarViewModel.convertDateForCheckArtistAvailabilityView(date: date), "1 January")
    }
    
    func testGivenFunctionDisplaySelectedDates_WhenMoreThanOneDate_ThenReturnsCorrectString() {
        let dates = ["1January2022", "10January2022"]
        XCTAssertEqual(calendarViewModel.displaySelectedDates(dates: dates), "2 dates")
    }
    
    func testGivenFunctionDisplaySelectedDates_WhenOneDateAndMoreThanOneDigit_ThenReturnsCorrectDate() {
        let dates = ["10January2022"]
        XCTAssertEqual(calendarViewModel.displaySelectedDates(dates: dates), "10 January")
    }
    
    func testGivenFunctionDisplaySelectedDates_WhenOneDateAndOneDigit_ThenReturnsCorrectDate() {
        let dates = ["1January2022"]
        XCTAssertEqual(calendarViewModel.displaySelectedDates(dates: dates), "1 January")
    }
}
