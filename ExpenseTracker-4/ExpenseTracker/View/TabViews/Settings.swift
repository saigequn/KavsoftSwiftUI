//
//  Settings.swift
//  ExpenseTracker
//
//  Created by JXW003 on 2023/12/29.
//

import SwiftUI

struct Settings: View {
    /// User Properties
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Section("User Name") {
                    TextField("User Name", text: $userName)
                }
                
                Section("App Lock") {
                    Toggle("Enabled App Lock", isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle("Lock When App Goes Background", isOn: $lockWhenAppGoesBackground)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    Settings()
}
