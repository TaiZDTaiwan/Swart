//
//  String+Extensions.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 23/02/2022.
//

import SwiftUI

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
