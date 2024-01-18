//
//  Tag.swift
//  TagTextField
//
//  Created by JXW003 on 2024/1/17.
//

import SwiftUI

struct Tag: Identifiable, Hashable {
    var id: UUID = .init()
    var value: String
    var isInitial: Bool = false
}
