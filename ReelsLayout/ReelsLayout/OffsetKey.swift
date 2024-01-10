//
//  OffsetKey.swift
//  ReelsLayout
//
//  Created by JXW003 on 2024/1/9.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

