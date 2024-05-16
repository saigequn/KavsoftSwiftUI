//
//  ContentView.swift
//  DateTextField
//
//  Created by JXW003 on 2024/5/16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var date: Date = .now
    
    var body: some View {
        NavigationStack {
            DateTF(date: $date) { date in
                return date.formatted()
            }
            .navigationTitle("Date Picker TextField")
        }
    }
}

#Preview {
    ContentView()
}
