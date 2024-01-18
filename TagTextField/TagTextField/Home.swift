//
//  Home.swift
//  TagTextField
//
//  Created by JXW003 on 2024/1/17.
//

import SwiftUI

struct Home: View {
    
    @State private var tags: [Tag] = []
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    TagField(tags: $tags)
                    
                    Text("Input tags separated by comma(,)")
                }
                .padding()
            }
            .navigationTitle("Tag Field")
        }
    }
}

#Preview {
    ContentView()
}
