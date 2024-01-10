//
//  Tab.swift
//  ScrollableTabView
//
//  Created by JXW003 on 2024/1/10.
//

import SwiftUI

enum Tab: String, CaseIterable {
    
    case chats = "Chats"
    case calls = "Calls"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .chats:
            return "bubble.left.and.bubble.right"
        case .calls:
            return "phone"
        case .settings:
            return "gear"
        }
    }
    
    var systemColor: Color {
        switch self {
        case .chats:
            return .green
        case .calls:
            return .red
        case .settings:
            return .purple
        }
    }
    
}
