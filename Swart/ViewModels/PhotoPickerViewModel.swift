//
//  PhotoPickerModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 15/10/2021.
//

import SwiftUI
import Photos

// Various methods to interact with media model, to add and delete medias.
class PhotoPickerViewModel: ObservableObject {
    
    // MARK: - Property
    @Published var items = [Media]()
    
    // MARK: - Methods
    func append(item: Media) {
        items.append(item)
    }
    
    func deleteItemAtGivenIndex(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    func deleteAll() {
        for index in items.indices {
            items[index].delete()
        }
        items.removeAll()
    }
}
