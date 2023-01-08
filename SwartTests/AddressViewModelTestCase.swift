//
//  AddressViewModelTestCase.swift
//  SwartTests
//
//  Created by Raphaël Huang-Dubois on 20/03/2022.
//

import XCTest
import MapKit
@testable import Swart

class AddressViewModelTestCase: XCTestCase {

    private var addressViewModel: AddressViewModel!
    
    override func setUp() {
        super.setUp()
        addressViewModel = AddressViewModel()
    }
    
    func testGivenFunctionCheckIfLocationServicesIsEnabled_WhenCall_ThenInitLocationManager() {
        addressViewModel.checkIfLocationServicesIsEnabled()
        XCTAssertNotNil(addressViewModel.locationManager)
    }
    
    func testGivenFunctionSelectAddressElement_WhenModifyElementHasText_ThenReturnModifyElement() {
        let modifyElement = "modifyElement"
        let currentElement = "currentElement"
        XCTAssertEqual(addressViewModel.selectAddressElement(modifyElement: modifyElement, currentElement: currentElement), modifyElement)
    }
    
    func testGivenFunctionSelectAddressElement_WhenModifyElementHasNoText_ThenReturnCurrentElement() {
        let modifyElement = ""
        let currentElement = "currentElement"
        XCTAssertEqual(addressViewModel.selectAddressElement(modifyElement: modifyElement, currentElement: currentElement), currentElement)
    }
    
    func testGivenFunctionDetermineDepartmentToSaveInDatabase_WhenIndicateValidPostalCode_ThenReturnCorrectDepartment() {
        let postalCode = "92270"
        XCTAssertEqual(addressViewModel.determineDepartmentToSaveInDatabase(postalCode: postalCode), "92 - Hauts-de-Seine")
    }
    
    func testGivenFunctionDetermineDepartmentToSaveInDatabase_WhenIndicateIncorrectPostalCode_ThenReturnEmptyString() {
        let postalCode = "postalCode"
        XCTAssertEqual(addressViewModel.determineDepartmentToSaveInDatabase(postalCode: postalCode), "")
    }
    
    func testGivenFunctionDetermineCity_WhenIndicateValidAddress_ThenReturnCorrectCity() {
        let address = "38 Rue De La Paix, 92270 Bois-Colombes, France"
        XCTAssertEqual(addressViewModel.determineCity(address: address), "Bois-Colombes")
    }
    
    func testGivenFunctionRewriteDepartment_WhenIndicateDepartment_ThenReturnExpectedDepartment() {
        let department = "92 - Hauts-de-Seine"
        XCTAssertEqual(addressViewModel.rewriteDepartment(department: department), "Hauts-de-Seine")
    }
    
    func testGivenFunctionDetermineLocation_WhenIsAnywhereSuitsYouAndYourPlace_ThenReturnArtist() {
        let selectedPlaceName = "Anywhere suits you"
        let artistPlace = "Your place"
        XCTAssertEqual(addressViewModel.determineLocation(selectedPlaceName: selectedPlaceName, artistPlace: artistPlace), "Artist's place")
    }
    
    func testGivenFunctionDetermineLocation_WhenIsAnywhereSuitsYou_ThenReturnArtist() {
        let selectedPlaceName = "Anywhere suits you"
        let artistPlace = "Anywhere suits you"
        XCTAssertEqual(addressViewModel.determineLocation(selectedPlaceName: selectedPlaceName, artistPlace: artistPlace), "Artist's place")
    }
    
    func testGivenFunctionDetermineLocation_WhenIsAnywhereSuitsYouAndAudiencePlace_ThenReturnYourPlace() {
        let selectedPlaceName = "Anywhere suits you"
        let artistPlace = "Audience's place"
        XCTAssertEqual(addressViewModel.determineLocation(selectedPlaceName: selectedPlaceName, artistPlace: artistPlace), "Your place")
    }
    
    func testGivenFunctionDetermineLocation_WhenSelectedPlaceNameIsEmpty_ThenReturnEmptyString() {
        let selectedPlaceName = ""
        let artistPlace = "Audience's place"
        XCTAssertEqual(addressViewModel.determineLocation(selectedPlaceName: selectedPlaceName, artistPlace: artistPlace), "")
    }
    
    func testGivenFunctionRetrieveAllAddressElements_WhenAValidAddressIsIndicated_ThenRetrieveCorrectlyAddressElements() {
        let address = "38 Rue De La Paix, 92270 Bois-Colombes, France"
        addressViewModel.retrieveAllAddressElements(address: address) { subThoroughfare in
            XCTAssertEqual(subThoroughfare, "38")
        } thoroughfare: { thoroughfare in
            XCTAssertEqual(thoroughfare, "Rue De La Paix")
        } locality: { locality in
            XCTAssertEqual(locality, "Bois-Colombes")
        } postalCode: { postalCode in
            XCTAssertEqual(postalCode, "92270")
        } country: { country in
            XCTAssertEqual(country, "France")
        }
    }
    
    func testGivenFunctionRetrieveAllAddressElements_WhenIncorrectAddressIsIndicated_ThenRetrieveEmptyStrings() {
        let address = ""
        addressViewModel.retrieveAllAddressElements(address: address) { subThoroughfare in
            XCTAssertEqual(subThoroughfare, "")
        } thoroughfare: { thoroughfare in
            XCTAssertEqual(thoroughfare, "")
        } locality: { locality in
            XCTAssertEqual(locality, "")
        } postalCode: { postalCode in
            XCTAssertEqual(postalCode, "")
        } country: { country in
            XCTAssertEqual(country, "")
        }
    }
}
