//
//  DatesFormattersViewModelTestCase.swift
//  SwartTests
//
//  Created by Raphaël Huang-Dubois on 18/03/2022.
//

import XCTest
@testable import Swart

class DatesFormattersViewModelTestCase: XCTestCase {

    private var datesFormattersViewModel: DatesFormattersViewModel!
    
    override func setUp() {
        super.setUp()
        datesFormattersViewModel = DatesFormattersViewModel()
    }
    
    func testGivenFunctionConvertDateToYear_WhenCall_ThenReturnCorrectString() {
       let date = "02/01/2022"
        XCTAssertEqual(datesFormattersViewModel.isolateYearFromGivenDate(date: date), "2022")
    }
    
    func testGivenFunctionConvertDateToMonth_WhenCall_ThenReturnCorrectString() {
       let date = "02/01/2022"
        XCTAssertEqual(datesFormattersViewModel.isolateMonthFromGivenDate(date: date), "02")
    }
    
    func testGivenFunctionConvertDateToDay_WhenCall_ThenReturnCorrectString() {
       let date = "02/01/2022"
        XCTAssertEqual(datesFormattersViewModel.isolateDayFromGivenDate(date: date), "01")
    }
    
    func testGivenFunctionUserIs18_WhenUserIsBelow18_ThenReturnFalse() {
       let today = Date()
        XCTAssertEqual(datesFormattersViewModel.userIs18(birthdate: today), false)
    }
    
    func testGivenFunctionUserIs18_WhenUserIsAbove18_ThenReturnTrue() {
        let date = "01/01/1996"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: date) {
            XCTAssertEqual(datesFormattersViewModel.userIs18(birthdate: date), true)
        }
    }
    
    func testGivenFunctionUserIs18_WhenUserGot18DuringTheYear_ThenReturnTrue() {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = -18
        let pastDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        if let date = pastDate {
            XCTAssertEqual(datesFormattersViewModel.userIs18(birthdate: date), true)
        }
    }
    
    func testGivenFunctionUserIs18_WhenUserIsMonthesFrom18_ThenReturnFalse() {
        let currentDate = Date()
        var firstDateComponent = DateComponents()
        firstDateComponent.year = -18
        let firstDate = Calendar.current.date(byAdding: firstDateComponent, to: currentDate)
        if let firstDate = firstDate {
            var secondDateComponent = DateComponents()
            secondDateComponent.month = 1
            let secondDate = Calendar.current.date(byAdding: secondDateComponent, to: firstDate)
            if let finalDate = secondDate {
                XCTAssertEqual(datesFormattersViewModel.userIs18(birthdate: finalDate), false)
            }
        }
    }
    
    func testGivenFunctionUserIs18_WhenUserIsDaysFrom18_ThenReturnFalse() {
        let currentDate = Date()
        var firstDateComponent = DateComponents()
        firstDateComponent.year = -18
        let firstDate = Calendar.current.date(byAdding: firstDateComponent, to: currentDate)
        if let firstDate = firstDate {
            var secondDateComponent = DateComponents()
            secondDateComponent.day = 1
            let secondDate = Calendar.current.date(byAdding: secondDateComponent, to: firstDate)
            if let finalDate = secondDate {
                XCTAssertEqual(datesFormattersViewModel.userIs18(birthdate: finalDate), false)
            }
        }
    }
    
    func testGivenFunctionUserIs18_WhenUserGot18MonthesAgo_ThenReturnTrue() {
        let currentDate = Date()
        var firstDateComponent = DateComponents()
        firstDateComponent.year = -18
        let firstDate = Calendar.current.date(byAdding: firstDateComponent, to: currentDate)
        if let firstDate = firstDate {
            var secondDateComponent = DateComponents()
            secondDateComponent.month = -1
            let secondDate = Calendar.current.date(byAdding: secondDateComponent, to: firstDate)
            if let finalDate = secondDate {
                XCTAssertEqual(datesFormattersViewModel.userIs18(birthdate: finalDate), true)
            }
        }
    }
    
    func testGivenFunctionUserIs18_WhenUserJustGot18_ThenReturnTrue() {
        let currentDate = Date()
        var firstDateComponent = DateComponents()
        firstDateComponent.year = -18
        let firstDate = Calendar.current.date(byAdding: firstDateComponent, to: currentDate)
        if let firstDate = firstDate {
            var secondDateComponent = DateComponents()
            secondDateComponent.day = -1
            let secondDate = Calendar.current.date(byAdding: secondDateComponent, to: firstDate)
            if let finalDate = secondDate {
                XCTAssertEqual(datesFormattersViewModel.userIs18(birthdate: finalDate), true)
            }
        }
    }
}
