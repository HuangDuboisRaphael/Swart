//
//  RequestUserCollectionViewModelTestCase.swift
//  SwartTests
//
//  Created by Raphaël Huang-Dubois on 17/03/2022.
//

import XCTest
@testable import Swart

class RequestUserCollectionViewModelTestCase: XCTestCase {
    
    private var requestUserCollectionViewModel: RequestUserCollectionViewModel!
    private var toTest = 0
    
    override func setUp() {
        super.setUp()
        requestUserCollectionViewModel = RequestUserCollectionViewModel()
    }
    
    func testGivenFunctionAddDates_WhenCall_ThenCorrectlyAddDates() {
        let date = "01/01/2022"
        requestUserCollectionViewModel.addDates(date: date) {}
        XCTAssertTrue(requestUserCollectionViewModel.dates == ["01/01/2022"])
    }
    
    func testGivenFunctionDetermineComingRequestDates_WhenCall_ThenObtainValidDatesArray() {
        let firstRequest = RequestUser(requestId: "", headline: "", city: "", department: "", address: "", date: "01/01/2022", location: "", guest: "", coverPhoto: "", accepted: false)
        let secondRequest = RequestUser(requestId: "", headline: "", city: "", department: "", address: "", date: "02/28/2022", location: "", guest: "", coverPhoto: "", accepted: false)
        requestUserCollectionViewModel.toReorderComingRequests.append(firstRequest)
        requestUserCollectionViewModel.toReorderComingRequests.append(secondRequest)
        requestUserCollectionViewModel.determineComingRequestDates {}
        XCTAssertTrue(requestUserCollectionViewModel.dates == ["01/01/2022", "02/28/2022"])
    }
    
    func testGivenFunctionDetermineComingRequestDates_WhenCall_ThenCompletionIsComplete() {
        requestUserCollectionViewModel.determineComingRequestDates {
            self.testing()
            XCTAssertTrue(self.toTest == 2)
        }
    }
    
    func testing() {
        toTest = 2
    }
    
    func testGivenFunctionIsRequestPassed_WhenApplyAPastBookingDate_ThenReturnTrue() {
        let pastBookingDate = "01/01/2022"
        requestUserCollectionViewModel.isRequestPassed(bookingDate: pastBookingDate) { past in
            XCTAssertTrue(past)
        }
    }
    
    func testGivenFunctionIsRequestPassed_WhenApplyAFutureBookingDate_ThenReturnFalse() {
        let futureBookingDate = "01/01/2100"
        requestUserCollectionViewModel.isRequestPassed(bookingDate: futureBookingDate) { future in
            XCTAssertFalse(future)
        }
    }
}
