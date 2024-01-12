//
//  AnchorKey.swift
//  ProgressHeroEffect
//
//  Created by JXW003 on 2024/1/12.
//

import SwiftUI


struct AnchorKey: PreferenceKey {
    
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { _, value in
            value
        }
    }
}

