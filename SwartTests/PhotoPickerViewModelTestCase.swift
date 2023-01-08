//
//  PhotoPickerViewModelTestCase.swift
//  SwartTests
//
//  Created by Raphaël Huang-Dubois on 19/03/2022.
//

import XCTest
@testable import Swart

class PhotoPickerViewModelTestCase: XCTestCase {

    private var photoPickerViewModel: PhotoPickerViewModel!
    
    override func setUp() {
        super.setUp()
        photoPickerViewModel = PhotoPickerViewModel()
    }
    
    func testGivenFunctionAppend_WhenCall_ThenAppendOneElementInItems() {
       let media = Media(with: UIImage())
        photoPickerViewModel.append(item: media)
        XCTAssertTrue(photoPickerViewModel.items.count == 1)
    }
    
    func testGivenFunctionDeleteItemAtGivenIndex_WhenCall_ThenDeleteSpecificItem() {
       let firstMedia = Media(with: UIImage())
        let secondMedia = Media(with: UIImage())
        photoPickerViewModel.append(item: firstMedia)
        photoPickerViewModel.append(item: secondMedia)
        photoPickerViewModel.deleteItemAtGivenIndex(at: [0])
        XCTAssertTrue(photoPickerViewModel.items[0] == secondMedia)
    }
    
    func testGivenFunctionDeleteAll_WhenCall_ThenDeleteAllElements() {
       let firstMedia = Media(with: UIImage())
        let secondMedia = Media(with: UIImage())
        photoPickerViewModel.append(item: firstMedia)
        photoPickerViewModel.append(item: secondMedia)
        photoPickerViewModel.deleteAll()
        XCTAssertTrue(photoPickerViewModel.items.count == 0)
    }
}
