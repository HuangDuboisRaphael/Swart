//
//  ArtisCollectionViewModelTestCase.swift
//  SwartTests
//
//  Created by Raphaël Huang-Dubois on 16/03/2022.
//

import XCTest
@testable import Swart

class ArtisCollectionViewModelTestCase: XCTestCase {
    
    private var artisCollectionViewModel: ArtistCollectionViewModel!
    
    override func setUp() {
        super.setUp()
        artisCollectionViewModel = ArtistCollectionViewModel()
    }
    
    func testGivenFunctionObtainArtContentMediaUrls_WhenCall_ThenObtainValidUrlArray() {
        artisCollectionViewModel.urlArrayForArtContent = ["image_2", "video_3", "image_1"]
        artisCollectionViewModel.orderArtContentMediaUrls {}
        XCTAssertTrue(artisCollectionViewModel.urlArrayForArtContent == ["image_1", "image_2", "video_3"])
    }
}
