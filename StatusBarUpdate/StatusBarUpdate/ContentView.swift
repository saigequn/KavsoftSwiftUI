//
//  ContentView.swift
//  StatusBarUpdate
//
//  Created by JXW003 on 2024/1/15.
//

import SwiftUI

struct ContentView: View {
    
    @State private var statusBarStyle: Style = .def
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $statusBarStyle) {
                    ForEach(Style.allCases, id: \.rawValue) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .onChange(of: statusBarStyle, initial: true) { oldValue, newValue in
                    UIApplication.shared.setStatusBarStyle(newValue.statusBarStyle)
                }
                
                Spacer()
            }
        }
        .padding()
    }
}

enum Style: String, CaseIterable {
    case def = "Default"
    case light = "Light"
    case dark = "Dark"
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .def:
            return .default
        case .light:
            return .lightContent
        case .dark:
            return .darkContent
        }
    }
}

#Preview {
    ContentView()
}
