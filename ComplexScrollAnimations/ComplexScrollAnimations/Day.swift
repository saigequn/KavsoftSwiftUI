//
//  Day.swift
//  ComplexScrollAnimations
//
//  Created by JXW003 on 2024/1/8.
//

import SwiftUI

struct Day: Identifiable {
    var id: UUID = .init()
    var shortSymbol: String
    var date: Date
    var ignored: Bool = false
}
