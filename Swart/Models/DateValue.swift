//
//  DateValue.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 26/12/2021.
//

import SwiftUI

struct DateValue: Identifiable, Hashable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
