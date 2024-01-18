//
//  ContentView.swift
//  SwipeToHideNavBar
//
//  Created by JXW003 on 2024/1/18.
//

import SwiftUI

struct ContentView: View {
    @State private var hideNavBar: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(1...50, id:\.self) { index in
                    
                    NavigationLink {
                        List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                            ForEach(1...50, id:\.self) { index in
                                Text("List Item \(index)")
                            }
                        }
                        .listStyle(.plain)
                        .navigationTitle("Detail View")
                    } label: {
                        Text("List Item \(index)")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Chat App")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        hideNavBar.toggle()
                    }, label: {
                        Image(systemName: hideNavBar ? "eye.slash" : "eye")
                    })
                }
            })
            .hideNavBarOnSwipe(true)
        }
    }
}

#Preview {
    ContentView()
}
