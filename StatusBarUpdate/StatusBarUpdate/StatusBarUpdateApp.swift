//
//  StatusBarUpdateApp.swift
//  StatusBarUpdate
//
//  Created by JXW003 on 2024/1/15.
//

import SwiftUI

@main
struct StatusBarUpdateApp: App {
    var body: some Scene {
        WindowGroup {
            StatusBarView {
                ContentView()
            }
        }
    }
}
