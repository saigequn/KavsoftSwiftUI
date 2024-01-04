//
//  OffsetKey.swift
//  ComplexHeroAnimation
//
//  Created by JXW003 on 2024/1/4.
//

import SwiftUI

/// Anchor Key
struct OffsetKey: PreferenceKey {
    
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) {
            $1
        }
    }
}

