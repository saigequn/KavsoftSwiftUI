//
//  Like.swift
//  ReelsLayout
//
//  Created by JXW003 on 2024/1/9.
//

import SwiftUI

struct Like: Identifiable {
    var id: UUID = .init()
    var tappedRect: CGPoint = .zero
    var isAnimated: Bool = false
}
