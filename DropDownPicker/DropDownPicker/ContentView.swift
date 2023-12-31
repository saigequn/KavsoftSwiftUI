//
//  ContentView.swift
//  DropDownPicker
//
//  Created by JXW003 on 2024/1/5.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection1: String?
    @State private var selection2: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                DropDownView(
                    hint: "Select",
                    options: [
                        "YouTube",
                        "Google",
                        "TikTok",
                        "Snapchat",
                        "Twitter",
                    ],
                    anchor: .bottom,
                    selection: $selection1
                )
                                
                DropDownView(
                    hint: "Select",
                    options: [
                        "YouTube",
                        "Google",
                        "TikTok",
                        "Snapchat",
                        "Twitter",
                    ],
                    anchor: .top,
                    selection: $selection2
                )
            }
            .navigationTitle("Dropdown Picker")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
