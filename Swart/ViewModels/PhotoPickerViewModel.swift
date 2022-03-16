//
//  PhotoPickerModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 15/10/2021.
//

import SwiftUI
import Photos

class PhotoPickerViewModel: ObservableObject {
    @Published var items = [Media]()
    
    func append(item: Media) {
        items.append(item)
    }
    
    func deleteItemAtGivenIndex(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    func deleteAll() {
        for (index, _) in items.enumerated() {
            items[index].delete()
        }
        items.removeAll()
    }
}
