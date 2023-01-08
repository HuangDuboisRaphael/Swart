//
//  RequestArtistCollectionViewModelTestCase.swift
//  SwartTests
//
//  Created by Raphaël Huang-Dubois on 17/03/2022.
//

import XCTest
@testable import Swart

class RequestArtistCollectionViewModelTestCase: XCTestCase {

    private var requestArtistCollectionViewModel: RequestArtistCollectionViewModel!
    private var toTest = 0
    
    override func setUp() {
        super.setUp()
        requestArtistCollectionViewModel = RequestArtistCollectionViewModel()
    }
    
    func testGivenFunctionAddDates_WhenCall_ThenCorrectlyAddDates() {
        let date = "01/01/2022"
        requestArtistCollectionViewModel.addDates(date: date) {}
        XCTAssertTrue(requestArtistCollectionViewModel.dates == ["01/01/2022"])
    }
    
    func testGivenFunctionDetermineComingRequestDates_WhenCall_ThenObtainValidDatesArray() {
        let firstRequest = RequestArtist(requestId: "", requestIdUser: "", idUser: "", firstName: "", city: "", department: "", address: "", date: "01/01/2022", location: "", guest: "", message: "", coverPhoto: "", accepted: false)
        let secondRequest = RequestArtist(requestId: "", requestIdUser: "", idUser: "", firstName: "", city: "", department: "", address: "", date: "02/28/2022", location: "", guest: "", message: "", coverPhoto: "", accepted: false)
        requestArtistCollectionViewModel.toReorderComingRequests.append(firstRequest)
        requestArtistCollectionViewModel.toReorderComingRequests.append(secondRequest)
        requestArtistCollectionViewModel.determineComingRequestDates {}
        XCTAssertTrue(requestArtistCollectionViewModel.dates == ["01/01/2022", "02/28/2022"])
    }
    
    func testGivenFunctionDetermineComingRequestDates_WhenCall_ThenCompletionIsComplete() {
        requestArtistCollectionViewModel.determineComingRequestDates {
            self.testing()
            XCTAssertTrue(self.toTest == 2)
        }
    }
    
    func testing() {
        toTest = 2
    }
    
    func testGivenFunctionIsRequestPassed_WhenApplyAPastBookingDate_ThenReturnTrue() {
        let pastBookingDate = "01/01/2022"
        requestArtistCollectionViewModel.isRequestPassed(bookingDate: pastBookingDate) { past in
            XCTAssertTrue(past)
        }
    }
    
    func testGivenFunctionIsRequestPassed_WhenApplyAFutureBookingDate_ThenReturnFalse() {
        let futureBookingDate = "01/01/2100"
        requestArtistCollectionViewModel.isRequestPassed(bookingDate: futureBookingDate) { future in
            XCTAssertFalse(future)
        }
    }
}
